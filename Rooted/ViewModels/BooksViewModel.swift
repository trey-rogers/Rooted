//
//  BooksViewModel.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//

import SwiftUI
import Observation

@Observable
class BooksViewModel {
    var books: [Book]

    init(books: [Book]) {
        self.books = books
    }
}
