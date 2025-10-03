import SwiftUI
import PencilKit

// MARK: - DrawingCanvasView
// A SwiftUI wrapper around PKCanvasView that binds its drawing to Data.
struct DrawingCanvasView: UIViewRepresentable {
    // Binding to the encoded PKDrawing data for persistence
    var data: Binding<Data?>
    var drawingPolicy: PKCanvasViewDrawingPolicy = .pencilOnly

    init(data: Binding<Data?>, drawingPolicy: PKCanvasViewDrawingPolicy = .pencilOnly) {
        self.data = data
        self.drawingPolicy = drawingPolicy
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = drawingPolicy
        canvas.delegate = context.coordinator
        canvas.alwaysBounceVertical = false
        canvas.alwaysBounceHorizontal = false
        // Load existing drawing if any
        if let d = data.wrappedValue, let drawing = try? PKDrawing(data: d) {
            canvas.drawing = drawing
        }
        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Sync external data into the canvas if it differs
        let current = uiView.drawing.dataRepresentation()
        if let d = data.wrappedValue {
            if current != d, let drawing = try? PKDrawing(data: d) {
                uiView.drawing = drawing
            }
        } else {
            // If binding is nil, clear the canvas
            if !uiView.drawing.strokes.isEmpty {
                uiView.drawing = PKDrawing()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(data: data)
    }

    // MARK: - Coordinator
    final class Coordinator: NSObject, PKCanvasViewDelegate {
        var data: Binding<Data?>
        private var isUpdating = false

        init(data: Binding<Data?>) {
            self.data = data
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            guard !isUpdating else { return }
            isUpdating = true
            let encoded = canvasView.drawing.dataRepresentation()
            data.wrappedValue = encoded
            isUpdating = false
        }
    }
}
