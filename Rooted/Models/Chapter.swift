//
//  Chapter.swift
//  Rooted
//
//  Created by Trey Rogers on 9/29/25.
//
import Foundation
import SwiftData

// MARK: - Chapter
@Model
class Chapter {
    @Attribute(.unique) var id: UUID
    var chapterNumber: Int
    var order: Int
    @Relationship(deleteRule: .cascade) var verses: [Verse]
    var note: Note

    init(id: UUID = UUID(), chapterNumber: Int, order: Int, verses: [Verse], note: Note = Note()) {
        self.id = id
        self.chapterNumber = chapterNumber
        self.order = order
        self.verses = verses
        self.note = note
    }

    convenience init(id: UUID = UUID(), chapterNumber: Int, order: Int, verses: [Verse], note: String = "", drawnNote: Data? = nil) {
        self.init(id: id, chapterNumber: chapterNumber, order: order, verses: verses, note: Note(text: note, drawingData: drawnNote))
    }
}
