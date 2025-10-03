//
//  BooksSidebarView.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//

import SwiftUI
import SwiftData

// MARK: - NotesView
struct NotesView: View {
    @Bindable var chapter: Chapter
    @State private var isExpanded: Bool = true
    @State private var isDrawSheetPresented = false
    
    var body: some View {
        VStack {
            if isExpanded {
                HStack {
                    Text("Notes")
                        .font(.headline)
                    Spacer()
                    NotesToolbar(isExpanded: isExpanded, onToggleNotes: { isExpanded.toggle() }, onShowDraw: { isDrawSheetPresented = true })
                }
                TextEditor(text: $chapter.note.text)
                    .frame(minHeight: 200)
                    .border(Color.secondary)
            } else {
                NotesToolbar(isExpanded: isExpanded, onToggleNotes: { isExpanded.toggle() }, onShowDraw: { isDrawSheetPresented = true })
            }
        }
        .sheet(isPresented: $isDrawSheetPresented) {
            DrawingEditorSheet(drawingData: $chapter.note.drawingData)
                .presentationDetents([.fraction(0.85)])
                .presentationSizing(.page)
        }
    }
    
    // MARK: - Toolbar
    private struct NotesToolbar: View {
        let isExpanded: Bool
        let onToggleNotes: () -> Void
        let onShowDraw: () -> Void
        
        var body: some View {
            HStack {
                Button(action: onToggleNotes) {
                    Image(systemName: isExpanded ? "list.clipboard" : "list.clipboard.fill")
                        .tint(.primary)
                }
                Button(action: onShowDraw) {
                    Image(systemName: "pencil.line")
                        .imageScale(.large)
                        .tint(.primary)
                        .accessibilityLabel("Show Draw Notes")
                }
            }
        }
    }
}

