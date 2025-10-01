//
//  BooksSidebarView.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//
import SwiftUI

struct BooksSidebarView: View {
    var viewModel: BooksViewModel
    @Binding var selectedBook: Book?
    
    var body: some View {
        List(viewModel.books, selection: $selectedBook) { book in
            NavigationLink(value: book) {
                Text(book.name)
            }
        }
        .navigationTitle("Books")
        .frame(width: 200)
    }
}
