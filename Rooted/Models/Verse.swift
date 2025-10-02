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
    var order: Int   // <-- NEW

    init(id: UUID = UUID(), verseNumber: Int, text: String, order: Int) {
        self.id = id
        self.verseNumber = verseNumber
        self.text = text
        self.order = order
    }
}
