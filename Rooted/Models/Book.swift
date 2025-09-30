//
//  Book.swift
//  Rooted
//
//  Created by Trey Rogers on 9/29/25.
//
import Foundation

// MARK: - Book
struct Book: Codable {
    let name: String
    let chapters: [Chapter]
}
