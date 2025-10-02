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
                    ForEach(chapter.verses, id: \.id) { verse in
                        Text("\(verse.verseNumber) \(verse.text)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }
            
            VStack(alignment: .leading) {
                Text("Notes").font(.headline)
                TextEditor(text: $chapter.note)
                    .frame(minHeight: 200)
                    .border(Color.secondary)
            }
            .frame(width: 250)
            .padding()
        }
        .padding()
        .navigationTitle(
            "\(bookName) \(chapter.chapterNumber):1-\(chapter.verses.count)"
        )
    }
}

