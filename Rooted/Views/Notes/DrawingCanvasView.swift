import SwiftUI
import PencilKit
import UIKit

// MARK: - DrawingCanvasView
// A SwiftUI wrapper around PKCanvasView with pinch-to-zoom via UIScrollView
// and an expanded drawable area so users can pan/draw beyond the initial viewport.
struct DrawingCanvasView: UIViewRepresentable {
    // SwiftUI bindings
    @Binding var data: Data?
    @Binding var zoomScale: CGFloat
    @Binding var contentOffset: CGPoint
    @Binding var canvasSize: CGSize

    // Configuration
    var drawingPolicy: PKCanvasViewDrawingPolicy = .pencilOnly
    var minZoomScale: CGFloat = 0.25
    var maxZoomScale: CGFloat = 4.0
    var showsSystemToolPicker: Bool = true

    // MARK: - Initializer
    init(
        data: Binding<Data?>,
        zoomScale: Binding<CGFloat> = .constant(1.0),
        contentOffset: Binding<CGPoint> = .constant(.zero),
        canvasSize: Binding<CGSize> = .constant(CGSize(width: 8000, height: 8000)),
        drawingPolicy: PKCanvasViewDrawingPolicy = .pencilOnly,
        minZoomScale: CGFloat = 0.25,
        maxZoomScale: CGFloat = 4.0,
        showsSystemToolPicker: Bool = true
    ) {
        self._data = data
        self._zoomScale = zoomScale
        self._contentOffset = contentOffset
        self._canvasSize = canvasSize
        self.drawingPolicy = drawingPolicy
        self.minZoomScale = minZoomScale
        self.maxZoomScale = maxZoomScale
        self.showsSystemToolPicker = showsSystemToolPicker
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = drawingPolicy
        canvas.delegate = context.coordinator

        // Zoom configuration
        canvas.minimumZoomScale = minZoomScale
        canvas.maximumZoomScale = maxZoomScale

        // Require two fingers to pan so one finger (or pencil) is reserved for drawing
        canvas.panGestureRecognizer.minimumNumberOfTouches = 2

        // Provide a large drawable content area so the user can pan and draw freely
        canvas.contentSize = canvasSize

        // Load existing drawing if any
        if let d = data, let drawing = try? PKDrawing(data: d) {
            context.coordinator.performWithoutNotifying {
                canvas.drawing = drawing
            }
            context.coordinator.lastEncoded = d
        }

        // Apply initial zoom from binding (clamped)
        let clampedZoom = clamp(zoomScale, min: minZoomScale, max: maxZoomScale)
        if zoomScale != clampedZoom { self.zoomScale = clampedZoom }
        canvas.zoomScale = clampedZoom

        // Apply initial content offset (will be clamped after layout in update)
        canvas.contentOffset = contentOffset

        return canvas
    }

    func updateUIView(_ canvas: PKCanvasView, context: Context) {
        // Keep configuration in sync so updates from SwiftUI propagate
        if canvas.drawingPolicy != drawingPolicy {
            canvas.drawingPolicy = drawingPolicy
        }

        if canvas.minimumZoomScale != minZoomScale {
            canvas.minimumZoomScale = minZoomScale
        }
        if canvas.maximumZoomScale != maxZoomScale {
            canvas.maximumZoomScale = maxZoomScale
        }

        // Clamp binding zoom if out of bounds and apply to canvas if needed
        let clampedZoom = clamp(zoomScale, min: minZoomScale, max: maxZoomScale)
        if !approxEqual(zoomScale, clampedZoom) {
            zoomScale = clampedZoom
        }
        if !approxEqual(canvas.zoomScale, clampedZoom) {
            context.coordinator.performWithoutNotifying {
                canvas.zoomScale = clampedZoom
            }
        }

        // Ensure contentSize stays in sync with the configured canvas size
        if canvas.contentSize != canvasSize {
            canvas.contentSize = canvasSize
        }

        // Clamp and apply content offset from binding
        let clampedOffset = clampContentOffset(desired: contentOffset, in: canvas)
        if !approxEqual(canvas.contentOffset, clampedOffset) {
            context.coordinator.performWithoutNotifying {
                canvas.contentOffset = clampedOffset
            }
        }
        if !approxEqual(contentOffset, clampedOffset) {
            contentOffset = clampedOffset
        }

        // Sync external data into the canvas if it differs from what we last encoded
        let coordinator = context.coordinator
        if let d = data {
            if coordinator.lastEncoded != d {
                let drawing = (try? PKDrawing(data: d)) ?? PKDrawing()
                coordinator.performWithoutNotifying {
                    canvas.drawing = drawing
                }
                coordinator.lastEncoded = d
            }
        } else {
            // If binding is nil, clear the canvas (and cache)
            if !canvas.drawing.strokes.isEmpty {
                coordinator.performWithoutNotifying {
                    canvas.drawing = PKDrawing()
                }
            }
            coordinator.lastEncoded = nil
        }

        // Manage system tool picker visibility after the canvas is attached to a window
        DispatchQueue.main.async {
            coordinator.updateToolPickerVisibility(for: canvas, visible: showsSystemToolPicker)
        }
    }

    static func dismantleUIView(_ uiView: PKCanvasView, coordinator: Coordinator) {
        // Hide and detach the tool picker, then clear delegate
        coordinator.updateToolPickerVisibility(for: uiView, visible: false)
        uiView.delegate = nil
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(
            data: $data,
            zoomScale: $zoomScale,
            contentOffset: $contentOffset,
            minZoom: minZoomScale,
            maxZoom: maxZoomScale
        )
    }

    // MARK: - Coordinator
    @MainActor
    final class Coordinator: NSObject, PKCanvasViewDelegate {
        var data: Binding<Data?>
        var zoomScale: Binding<CGFloat>
        var contentOffset: Binding<CGPoint>
        private var isUpdating = false
        var lastEncoded: Data? // cache to avoid re-encoding for equality checks
        private let minZoom: CGFloat
        private let maxZoom: CGFloat

        // System tool picker management
        private var toolPicker: PKToolPicker?
        private var isToolPickerVisible: Bool = false

        init(
            data: Binding<Data?>,
            zoomScale: Binding<CGFloat>,
            contentOffset: Binding<CGPoint>,
            minZoom: CGFloat,
            maxZoom: CGFloat
        ) {
            self.data = data
            self.zoomScale = zoomScale
            self.contentOffset = contentOffset
            self.minZoom = minZoom
            self.maxZoom = maxZoom
        }

        func performWithoutNotifying(_ action: () -> Void) {
            isUpdating = true
            action()
            isUpdating = false
        }

        // MARK: System Tool Picker
        func updateToolPickerVisibility(for canvas: PKCanvasView, visible: Bool) {
            if visible {
                guard let window = canvas.window else { return }
                if toolPicker == nil {
                    toolPicker = PKToolPicker.shared(for: window)
                }
                guard let picker = toolPicker else { return }
                // Attach and show
                if !isToolPickerVisible {
                    picker.setVisible(true, forFirstResponder: canvas)
                    picker.addObserver(canvas)
                    canvas.becomeFirstResponder()
                    isToolPickerVisible = true
                }
            } else {
                guard let picker = toolPicker else { return }
                if isToolPickerVisible {
                    picker.setVisible(false, forFirstResponder: canvas)
                    picker.removeObserver(canvas)
                    isToolPickerVisible = false
                }
            }
        }

        // MARK: UIScrollViewDelegate via PKCanvasViewDelegate
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            guard !isUpdating else { return }
            let z = max(minZoom, min(maxZoom, scrollView.zoomScale))
            if !approxEqual(zoomScale.wrappedValue, z) {
                zoomScale.wrappedValue = z
            }
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard !isUpdating else { return }
            let offset = scrollView.contentOffset
            if !approxEqual(contentOffset.wrappedValue, offset) {
                contentOffset.wrappedValue = offset
            }
        }

        // MARK: PKCanvasViewDelegate
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            guard !isUpdating else { return }
            let encoded = canvasView.drawing.dataRepresentation()
            lastEncoded = encoded
            data.wrappedValue = encoded
        }
    }
}

// MARK: - Helpers
private func clamp(_ value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    return Swift.max(min, Swift.min(max, value))
}

private func approxEqual(_ a: CGFloat, _ b: CGFloat, epsilon: CGFloat = 0.0001) -> Bool {
    return abs(a - b) <= epsilon
}

private func approxEqual(_ a: CGPoint, _ b: CGPoint, epsilon: CGFloat = 0.5) -> Bool {
    return approxEqual(a.x, b.x, epsilon: epsilon) && approxEqual(a.y, b.y, epsilon: epsilon)
}

private func clampContentOffset(desired: CGPoint, in scrollView: UIScrollView) -> CGPoint {
    let boundsSize = scrollView.bounds.size
    let contentSize = scrollView.contentSize

    let maxX = max(0, contentSize.width - boundsSize.width)
    let maxY = max(0, contentSize.height - boundsSize.height)

    let clampedX = min(max(0, desired.x), maxX)
    let clampedY = min(max(0, desired.y), maxY)

    return CGPoint(x: clampedX, y: clampedY)
}
