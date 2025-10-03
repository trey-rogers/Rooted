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
    @Binding var isExpanded: Bool
    @Binding var isDrawSheetPresented: Bool
    
    var body: some View {
        if isExpanded {
            VStack(alignment: .leading) {
                Text("Notes")
                    .font(.headline)
                TextEditor(text: $chapter.note.text)
                    .frame(minHeight: 200)
                    .border(Color.secondary)
            }
        }
    }
}
