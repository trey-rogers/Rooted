//
//  BooksSidebarView.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//
import SwiftUI

struct ChaptersSidebarView: View {
    var book: Book
    @Binding var selectedChapter: Chapter?

    var body: some View {
        List(book.chapters.sorted(by: { $0.order < $1.order }), selection: $selectedChapter) { chapter in
            NavigationLink(value: chapter) {
                Text("Chapter \(chapter.chapterNumber)")
            }
        }
        .navigationTitle("Chapters")
    }
}
