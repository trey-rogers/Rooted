//
//  Chapter.swift
//  Rooted
//
//  Created by Trey Rogers on 9/29/25.
//
import Foundation

// MARK: - Chapter
struct Chapter: Codable {
    let chapterNumber: Int
    let verses: [Verse]
}
