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
    func toModel(order: Int) -> Chapter {
        Chapter(
            chapterNumber: chapterNumber,
            order: order,
            verses: verses.enumerated().map { idx, verse in
                verse.toModel(order: idx)
            }
        )
    }
}
