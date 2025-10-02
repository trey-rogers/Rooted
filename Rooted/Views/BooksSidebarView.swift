//
//  BooksSidebarView.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//
import SwiftUI
import SwiftData

struct BooksSidebarView: View {
    @Query var books: [Book]
    @Binding var selectedBook: Book?
    
    var body: some View {
        List(books, selection: $selectedBook) { book in
            NavigationLink(value: book) {
                Text(book.name)
            }
        }
        .navigationTitle("Books")
        .frame(width: 200)
    }
}
