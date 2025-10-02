//
//  BooksSidebarView.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//
import SwiftUI

struct ChapterDetailView: View {
    @Bindable var chapter: Chapter
    var bookName: String

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
            NotesView(chapter: chapter)
        }
        .padding()
        .navigationTitle(
            "\(bookName) \(chapter.chapterNumber):1-\(chapter.verses.count)"
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}
