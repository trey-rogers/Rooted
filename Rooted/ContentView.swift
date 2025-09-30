//
//  ContentView.swift
//  Rooted
//
//  Created by Trey Rogers on 9/29/25.
//

import SwiftUI
import Foundation

struct ContentView: View {
    let bible: Bible = BibleProvider.shared
    @State private var selectedBook: Book?
    @State private var selectedChapter: Chapter?
    
    var body: some View {
        NavigationSplitView {
            List(bible.books, selection: $selectedBook) { book in
                Text(book.name)
                    .onTapGesture {
                        selectedBook = book
                    }
            }
            .navigationTitle("Books")
        } content: {
            if let book = selectedBook {
                List(book.chapters, selection: $selectedChapter) { chapter in
                    Text(chapter.chapterNumber.description)
                        .onTapGesture {
                            selectedChapter = chapter
                        }
                }
                .navigationTitle("Chapters")
            } else {
                Text("Select a Book")
            }
        } detail: {
            if let chapter = selectedChapter {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(chapter.verses, id: \.verseNumber) { verse in
                            Text("\(verse.verseNumber) \(verse.text)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                }
                .navigationTitle("\(selectedBook?.name.appending(":") ?? "") \(chapter.chapterNumber): 1-\(chapter.verses.count)")
            } else {
                Text("Select a Chapter")
            }
        }
    }
}


#Preview {
    ContentView()
}
