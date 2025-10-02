//
//  Book.swift
//  Rooted
//
//  Created by Trey Rogers on 9/29/25.
//
import Foundation
import SwiftData

// MARK: - Book

@Model
class Book {
    @Attribute(.unique) var id: UUID
    var name: String
    var order: Int  // <-- NEW
    @Relationship(deleteRule: .cascade) var chapters: [Chapter]

    init(id: UUID = UUID(), name: String, order: Int, chapters: [Chapter]) {
        self.id = id
        self.name = name
        self.order = order
        self.chapters = chapters
    }
}
