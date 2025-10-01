//
//  BooksSidebarView.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//
import SwiftUI

struct ChaptersSidebarView: View {
    var viewModel: ChaptersViewModel
    @Binding var selectedChapter: Chapter?
    
    var body: some View {
        List(viewModel.chapters, selection: $selectedChapter) { chapter in
            NavigationLink(value: chapter) {
                Text("Chapter \(chapter.chapterNumber)")
            }
        }
        .navigationTitle("Chapters")
        .frame(width: 200)
    }
}
