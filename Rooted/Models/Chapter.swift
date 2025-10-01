//
//  Chapter.swift
//  Rooted
//
//  Created by Trey Rogers on 9/29/25.
//
import Foundation

// MARK: - Chapter
struct Chapter: Codable, Identifiable, Hashable, Equatable {
    let id: UUID = UUID()
    let chapterNumber: Int
    let verses: [Verse]
    let note: String = ""
    
    enum CodingKeys: String, CodingKey {
        case chapterNumber, verses
    }
}
