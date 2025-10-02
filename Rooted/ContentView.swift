//
//  ContentView.swift
//  Rooted
//
//  Created by Trey Rogers on 9/29/25.
//

import SwiftUI
import Foundation
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @State private var selectedBook: Book?
    @State private var selectedChapter: Chapter?
    
    var body: some View {
        NavigationSplitView {
            BooksSidebarView(selectedBook: $selectedBook)
        } content: {
            if let book = selectedBook {
                ChaptersSidebarView(book: book, selectedChapter: $selectedChapter)
            } else {
                PlaceholderView(text: "Select a Book")
            }
        } detail: {
            if let chapter = selectedChapter, let book = selectedBook {
                ChapterDetailView(chapter: chapter, bookName: book.name)
            } else {
                PlaceholderView(text: "Select a Chapter")
            }
        }
        .task {
            BibleProvider.loadData(context: context)
        }
    }
}


#Preview {
    ContentView()
}
