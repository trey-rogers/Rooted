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
    @Relationship(deleteRule: .cascade) var chapters: [Chapter]

    init(id: UUID = UUID(), name: String, chapters: [Chapter]) {
        self.id = id
        self.name = name
        self.chapters = chapters
    }
}
