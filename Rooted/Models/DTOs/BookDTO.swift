//
//  BookDTO.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//

struct BookDTO: Codable {
    let name: String
    let chapters: [ChapterDTO]
}

extension BookDTO {
    func toModel() -> Book {
        Book(
            name: name,
            chapters: chapters.map { $0.toModel() }
        )
    }
}
