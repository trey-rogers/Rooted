//
//  DrawingEditorSheet.swift
//  Rooted
//
//  Created by Trey Rogers on 10/2/25.
//
import SwiftUI
import PencilKit
import SwiftData

// MARK: - DrawingEditorSheet
struct DrawingEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Binding var drawingData: Data?
    @State private var showToolPicker: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Light background to contrast ink
                Color(.systemBackground)
                    .ignoresSafeArea()
                DrawingCanvasView(
                    data: $drawingData,
                    drawingPolicy: .anyInput,
                    showsSystemToolPicker: showToolPicker
                )
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationTitle("Draw Notes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Clear") {
                        drawingData = nil
                    }
                    .disabled(drawingData == nil)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showToolPicker.toggle()
                    } label: {
                        Image(systemName: showToolPicker ? "paintpalette.fill" : "paintpalette")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        do {
                            try modelContext.save()
                        } catch {
                            // Handle save error as needed; for now we just print
                            #if DEBUG
                            print("Failed to save drawing: \(error)")
                            #endif
                        }
                        dismiss()
                    }
                }
            }
        }
    }
}
