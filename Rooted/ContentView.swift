//
//  ContentView.swift
//  Rooted
//
//  Created by Trey Rogers on 9/29/25.
//

import SwiftUI
import Foundation
import SwiftData

// MARK: - ContentView
struct ContentView: View {
    @Environment(\.modelContext) private var context
    @State private var selectedBook: Book?
    @State private var selectedChapter: Chapter?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var containerSize: CGSize = .zero
    
    var body: some View {
        GeometryReader { proxy in
            let newSize = proxy.size
            let isLandscape = newSize.width > newSize.height
            
            NavigationSplitView(columnVisibility: $columnVisibility) {
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
            // track size so rotation updates
            .onChange(of: newSize) { _, newValue in
                containerSize = newValue
                let landscape = newValue.width > newValue.height
                columnVisibility = landscape ? .all : .detailOnly
            }
            .onAppear {
                containerSize = newSize
                columnVisibility = isLandscape ? .all : .detailOnly
            }
            // ✅ auto-collapse when chapter selected in portrait
            .onChange(of: selectedChapter) { _, newValue in
                if newValue != nil && containerSize.width < containerSize.height {
                    // only collapse in portrait
                    columnVisibility = .detailOnly
                }
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
