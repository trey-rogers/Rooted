//
//  ChaptersViewModel.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//

import SwiftUI
import Observation

@Observable
class ChaptersViewModel {
    var book: Book
    var chapters: [Chapter] { book.chapters }
    init(book: Book) {
        self.book = book
    }
}
