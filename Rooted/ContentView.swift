//
//  ContentView.swift
//  Rooted
//
//  Created by Trey Rogers on 9/29/25.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var selectedBook: Book?
    @State private var selectedChapter: Chapter?
    
    let bible = BibleProvider.shared
    
    var body: some View {
        NavigationSplitView {
            BooksSidebarView(
                viewModel: BooksViewModel(bible: bible),
                selectedBook: $selectedBook
            )
        } content: {
            if let book = selectedBook {
                ChaptersSidebarView(
                    viewModel: ChaptersViewModel(book: book),
                    selectedChapter: $selectedChapter
                )
            } else {
                VStack {
                    Image(systemName: "hand.tap")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text("Select a Book")
                        .font(.title2)
                }
                .opacity(0.25)
            }
        } detail: {
            if let chapter = selectedChapter, let book = selectedBook {
                ChapterDetailView(
                    viewModel: ChapterDetailViewModel(chapter: chapter),
                    bookName: book.name
                )
            } else {
                VStack {
                    Image(systemName: "hand.tap")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text("Select a Chapter")
                        .font(.title2)
                }
                .opacity(0.25)
            }
        }
    }
}




#Preview {
    ContentView()
}
