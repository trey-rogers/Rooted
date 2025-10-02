//
//  BookDTO.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//

struct ChapterDTO: Codable {
    let chapterNumber: Int
    let verses: [VerseDTO]
}


extension ChapterDTO {
    func toModel() -> Chapter {
        Chapter(
            chapterNumber: chapterNumber,
            verses: verses.map { $0.toModel() }
        )
    }
}
