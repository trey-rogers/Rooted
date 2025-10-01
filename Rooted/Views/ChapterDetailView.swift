//
//  BooksSidebarView.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//
import SwiftUI

struct ChapterDetailView: View {
    var viewModel: ChapterDetailViewModel
    @State var notesVM = NotesViewModel()
    var bookName: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.chapter.verses, id: \.verseNumber) { verse in
                        Text("\(verse.verseNumber) \(verse.text)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }
            
            NotesView(viewModel: notesVM)
        }
        .padding()
        .navigationTitle(
            "\(bookName) \(viewModel.chapter.chapterNumber):1-\(viewModel.chapter.verses.count)"
        )
    }
}
