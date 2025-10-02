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
    func toModel(order: Int) -> Book {
        Book(
            name: name,
            order: order,
            chapters: chapters.enumerated().map { idx, chapter in
                chapter.toModel(order: idx)
            }
        )
    }
}
