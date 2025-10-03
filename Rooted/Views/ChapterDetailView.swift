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
    
    @State private var isExpanded: Bool = false
    @State private var isDrawSheetPresented = false
    
    var body: some View {
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
        .padding()
        .navigationTitle(
            "\(bookName) \(chapter.chapterNumber):1-\(chapter.verses.count)"
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    isExpanded.toggle()
                } label: {
                    Image(systemName: isExpanded ? "list.clipboard" : "list.clipboard.fill")
                        .font(.title2)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isDrawSheetPresented = true
                } label: {
                    Image(systemName: "pencil.line")
                        .font(.title2)
                }
            }
        }
        .sheet(isPresented: $isDrawSheetPresented) {
            DrawingEditorSheet(drawingData: $chapter.note.drawingData)
                .presentationDetents([.fraction(0.85)])
                .presentationSizing(.page)
        }
    }
}
