import SwiftUI
import PencilKit
import UIKit

// MARK: - DrawingCanvasView
// A SwiftUI wrapper around PKCanvasView with pinch-to-zoom via UIScrollView
// and an expanded drawable area so users can pan/draw beyond the initial viewport.
struct DrawingCanvasView: UIViewRepresentable {
    // Use @Binding for idiomatic SwiftUI bindings
    @Binding var data: Data?

    // Zoom and drawing configuration
    var drawingPolicy: PKCanvasViewDrawingPolicy = .pencilOnly

    var minZoomScale: CGFloat = 0.25
    var maxZoomScale: CGFloat = 4.0
    var initialZoomScale: CGFloat = 1.0

    // Drawable canvas size (logical points)
    // Provide a large default so users can pan and draw outside the initial visible area.
    var canvasSize: CGSize = CGSize(width: 8000, height: 8000)

    // MARK: - Initializer
    init(
        data: Binding<Data?>,
        drawingPolicy: PKCanvasViewDrawingPolicy = .pencilOnly,
        minZoomScale: CGFloat = 0.25,
        maxZoomScale: CGFloat = 4.0,
        initialZoomScale: CGFloat = 1.0,
        canvasSize: CGSize = CGSize(width: 8000, height: 8000)
    ) {
        self._data = data
        self.drawingPolicy = drawingPolicy
        self.minZoomScale = minZoomScale
        self.maxZoomScale = maxZoomScale
        self.initialZoomScale = initialZoomScale
        self.canvasSize = canvasSize
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = drawingPolicy
        canvas.delegate = context.coordinator

        // PKCanvasView is a UIScrollView; configure zooming and panning here
        canvas.minimumZoomScale = minZoomScale
        canvas.maximumZoomScale = maxZoomScale

        // Require two fingers to pan so one finger (or pencil) is reserved for drawing
        canvas.panGestureRecognizer.minimumNumberOfTouches = 2

        // Often unnecessary in SwiftUI, but harmless if you need it
        canvas.contentInsetAdjustmentBehavior = .never

        // Provide a large drawable content area so the user can pan and draw freely
        canvas.contentSize = canvasSize

        // Load existing drawing if any
        if let d = data, let drawing = try? PKDrawing(data: d) {
            context.coordinator.performWithoutNotifying {
                canvas.drawing = drawing
            }
            context.coordinator.lastEncoded = d
        }

        // Clamp and apply initial zoom
        let clampedInitial = max(minZoomScale, min(maxZoomScale, initialZoomScale))
        canvas.zoomScale = clampedInitial

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

        // Clamp zoom if bounds changed
        if canvas.zoomScale < minZoomScale || canvas.zoomScale > maxZoomScale {
            canvas.zoomScale = max(minZoomScale, min(maxZoomScale, canvas.zoomScale))
        }

        // Ensure contentSize stays in sync with the configured canvas size
        if canvas.contentSize != canvasSize {
            canvas.contentSize = canvasSize
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
    }

    static func dismantleUIView(_ uiView: PKCanvasView, coordinator: Coordinator) {
        uiView.delegate = nil
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(data: $data)
    }

    // MARK: - Coordinator
    @MainActor
    final class Coordinator: NSObject, PKCanvasViewDelegate {
        var data: Binding<Data?>
        private var isUpdating = false
        var lastEncoded: Data? // cache to avoid re-encoding for equality checks

        init(data: Binding<Data?>) {
            self.data = data
        }

        func performWithoutNotifying(_ action: () -> Void) {
            isUpdating = true
            action()
            isUpdating = false
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
