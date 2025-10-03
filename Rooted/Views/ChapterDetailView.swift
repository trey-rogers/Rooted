//
//  BooksSidebarView.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//
import SwiftUI

// MARK: - ChapterDetailView
struct ChapterDetailView: View {
    @Bindable var chapter: Chapter
    var bookName: String
    
    @State private var isExpanded: Bool = true
    @State private var isDrawSheetPresented = false
    
    var body: some View {
        VStack {
            // Toolbar now at top of the detail view
            NotesToolbar(
                isExpanded: isExpanded,
                onToggleNotes: { isExpanded.toggle() },
                onShowDraw: { isDrawSheetPresented = true }
            )
            
            HStack(alignment: .top, spacing: 16) {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(chapter.verses.sorted(by: { $0.order < $1.order })) { verse in
                            Text("\(verse.verseNumber) \(verse.text)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                }
                
                NotesView(
                    chapter: chapter,
                    isExpanded: $isExpanded,
                    isDrawSheetPresented: $isDrawSheetPresented
                )
            }
        }
        .padding()
        .navigationTitle(
            "\(bookName) \(chapter.chapterNumber):1-\(chapter.verses.count)"
        )
        .navigationBarTitleDisplayMode(.inline)
        
        // 👇 Attach the sheet here so the toolbar button works
        .sheet(isPresented: $isDrawSheetPresented) {
            DrawingEditorSheet(drawingData: $chapter.note.drawingData)
                .presentationDetents([.fraction(0.85)])
                .presentationSizing(.page)
        }
    }
}
