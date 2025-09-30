//
//  ContentView.swift
//  Rooted
//
//  Created by Trey Rogers on 9/29/25.
//

import SwiftUI
import Foundation

import SwiftUI

struct ContentView: View {
    let bible: Bible = BibleProvider.shared
    @State private var selectedBook: Book?
    @State private var selectedChapter: Chapter?
    @State private var notesText: String = ""
    @State private var notesExpanded: Bool = true

    var body: some View {
        NavigationSplitView {
            List(bible.books, selection: $selectedBook) { book in
                NavigationLink(value: book) {
                    Text(book.name)
                }
            }
            .navigationTitle("Books")
            .frame(width: 200.0)
        } content: {
            if let book = selectedBook {
                List(book.chapters, selection: $selectedChapter) { chapter in
                    NavigationLink(value: chapter) {
                        Text("Chapter \(chapter.chapterNumber)")
                    }
                }
                .navigationTitle("Chapters")
                .frame(width: 200.0)
            } else {
                Text("Select a Book")
            }
        } detail: {
            if let chapter = selectedChapter {
                HStack(alignment: .top, spacing: 16) {
                    ScrollView {
                        VStack {
                            ForEach(chapter.verses, id: \.verseNumber) { verse in
                                Text("\(verse.verseNumber) \(verse.text)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding()
                    }
                    ZStack(alignment: .topLeading) {
                        if notesExpanded {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Button(action: { notesExpanded.toggle() }) {
                                        Image(systemName: "chevron.right")
                                    }
                                    Text("Notes").font(.headline)
                                }
                                TextEditor(text: $notesText)
                                    .frame(minHeight: 200)
                                    .border(Color.secondary)
                            }
                            .padding()
                        } else {
                            VStack {
                                Button(action: { notesExpanded.toggle() }) {
                                    Image(systemName: "chevron.left")
                                        .padding(.top, 8)
                                }
                                Spacer()
                            }
                        }
                    }
                    .frame(width: notesExpanded ? 250 : 32)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .animation(.easeInOut(duration: 0.2), value: notesExpanded)
                }
                .padding()
                .navigationTitle(
                    "\(selectedBook?.name ?? "") \(chapter.chapterNumber):1-\(chapter.verses.count)"
                )
            } else {
                Text("Select a Chapter")
            }
        }
    }
}



#Preview {
    ContentView()
}
