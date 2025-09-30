//
//  Verse.swift
//  Rooted
//
//  Created by Trey Rogers on 9/29/25.
//
import Foundation

// MARK: - Verse
struct Verse: Codable, Identifiable, Hashable, Equatable {
    let id: UUID = UUID()
    let verseNumber: Int
    let text: String
}
