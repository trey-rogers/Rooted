//
//  BookDTO.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//

struct VerseDTO: Codable {
    let verseNumber: Int
    let text: String
}

extension VerseDTO {
    func toModel(order: Int) -> Verse {
        Verse(
            verseNumber: verseNumber,
            text: text,
            order: order
        )
    }
}
