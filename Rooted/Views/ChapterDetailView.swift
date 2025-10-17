//
//  BooksSidebarView.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//
import SwiftUI
import PencilKit

// MARK: - ChapterDetailView
struct ChapterDetailView: View {
    @Bindable var chapter: Chapter
    var bookName: String
    
    @State private var isExpanded: Bool = false
    @State private var isDrawSheetPresented = false
    @State private var isDrawModeEnabled: Bool = false // Manage draw mode state
    
    @State private var zoomScale: CGFloat = 1.0
    @State private var contentOffset: CGPoint = .zero
    @State private var canvasSize: CGSize = CGSize(width: 1200, height: 2000)
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ScrollView {
                // Overlay DrawingCanvasView on top of verses list when draw mode is enabled
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        ForEach(chapter.verses.sorted(by: { $0.order < $1.order })) { verse in
                            Text("\(verse.verseNumber) \(verse.text)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                    
                    if isDrawModeEnabled {
                        DrawingCanvasView(
                            data: $chapter.note.drawingData,
                            zoomScale: $zoomScale,
                            contentOffset: $contentOffset,
                            canvasSize: $canvasSize,
                            drawingPolicy: .anyInput,
                            showsSystemToolPicker: true
                        )
                        .allowsHitTesting(true)
                        .background(Color.clear)
                        .opacity(0.8)
                        .padding(.horizontal)
                    }
                }
            }
            
            NotesView(
                chapter: chapter,
                isExpanded: $isExpanded,
                isDrawSheetPresented: $isDrawSheetPresented
            )
        }
        .padding()
        .navigationTitle(
            "\(bookName) \(chapter.chapterNumber):1-\(chapter.verses.count)"
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            NotesToolbar(
                isExpanded: $isExpanded,
                isDrawSheetPresented: $isDrawSheetPresented
            )
            
            // Toolbar button to toggle draw mode
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isDrawModeEnabled.toggle()
                } label: {
                    Image(systemName: isDrawModeEnabled ? "pencil.circle.fill" : "pencil.circle")
                }
                .accessibilityLabel(isDrawModeEnabled ? "Disable draw mode" : "Enable draw mode")
            }
        }
        .sheet(isPresented: $isDrawSheetPresented) {
            DrawingEditorSheet(drawingData: $chapter.note.drawingData)
                .presentationDetents([.large])
                .presentationSizing(.page)
        }
    }
}
