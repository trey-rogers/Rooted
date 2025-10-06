import SwiftUI
import PencilKit
import UIKit

// MARK: - DrawingCanvasView
// A SwiftUI wrapper around PKCanvasView with pinch-to-zoom via UIScrollView
// and an expanded drawable area so users can pan/draw beyond the initial viewport.
struct DrawingCanvasView: UIViewRepresentable {
    // Binding to the encoded PKDrawing data for persistence
    var data: Binding<Data?>
    var drawingPolicy: PKCanvasViewDrawingPolicy = .pencilOnly

    // Zoom configuration
    var minZoomScale: CGFloat = 0.25
    var maxZoomScale: CGFloat = 4.0
    var initialZoomScale: CGFloat = 1.0

    // Drawable canvas size (logical points)
    // Provide a large default so users can pan and draw outside the initial visible area.
    var canvasSize: CGSize = CGSize(width: 8000, height: 8000)

    // MARK: - Initializers
    init(
        data: Binding<Data?>,
        drawingPolicy: PKCanvasViewDrawingPolicy = .pencilOnly
    ) {
        self.data = data
        self.drawingPolicy = drawingPolicy
    }

    init(
        data: Binding<Data?>,
        drawingPolicy: PKCanvasViewDrawingPolicy = .pencilOnly,
        minZoomScale: CGFloat = 0.25,
        maxZoomScale: CGFloat = 4.0,
        initialZoomScale: CGFloat = 1.0,
        canvasSize: CGSize = CGSize(width: 8000, height: 8000)
    ) {
        self.data = data
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

        // Prevent automatic inset adjustments
        canvas.contentInsetAdjustmentBehavior = .never

        // Load existing drawing if any
        if let d = data.wrappedValue, let drawing = try? PKDrawing(data: d) {
            canvas.drawing = drawing
        }

        // Provide a large drawable content area so the user can pan and draw freely
        canvas.contentSize = canvasSize

        // Clamp and apply initial zoom
        let clampedInitial = max(minZoomScale, min(maxZoomScale, initialZoomScale))
        canvas.zoomScale = clampedInitial

        return canvas
    }

    func updateUIView(_ canvas: PKCanvasView, context: Context) {
        // Sync external data into the canvas if it differs
        let current = canvas.drawing.dataRepresentation()
        if let d = data.wrappedValue {
            if current != d, let drawing = try? PKDrawing(data: d) {
                canvas.drawing = drawing
            }
        } else {
            // If binding is nil, clear the canvas
            if !canvas.drawing.strokes.isEmpty {
                canvas.drawing = PKDrawing()
            }
        }

        // Ensure contentSize stays in sync with the configured canvas size
        if canvas.contentSize != canvasSize {
            canvas.contentSize = canvasSize
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(data: data)
    }

    // MARK: - Coordinator
    final class Coordinator: NSObject, PKCanvasViewDelegate, UIScrollViewDelegate {
        var data: Binding<Data?>
        private var isUpdating = false

        init(data: Binding<Data?>) {
            self.data = data
        }

        // MARK: PKCanvasViewDelegate
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            guard !isUpdating else { return }
            isUpdating = true
            let encoded = canvasView.drawing.dataRepresentation()
            data.wrappedValue = encoded
            isUpdating = false
        }
    }
}
