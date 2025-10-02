//
//  Verse.swift
//  Rooted
//
//  Created by Trey Rogers on 9/29/25.
//
import Foundation
import SwiftData

// MARK: - Verse
@Model
class Verse {
    @Attribute(.unique) var id: UUID
    var verseNumber: Int
    var text: String

    init(id: UUID = UUID(), verseNumber: Int, text: String) {
        self.id = id
        self.verseNumber = verseNumber
        self.text = text
    }
}
