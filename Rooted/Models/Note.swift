//
//  Note.swift
//  Rooted
//
//  Created by Trey Rogers on 10/3/25.
//

import Foundation

/// A value type that encapsulates a chapter's textual note and optional drawing data.
/// Stored in SwiftData as a transformable (Codable) attribute.
struct Note: Codable, Hashable, Sendable {
    /// The textual content of the note.
    var text: String
    /// Optional binary data representing a drawing or sketch associated with the note.
    var drawingData: Data?

    init(text: String = "", drawingData: Data? = nil) {
        self.text = text
        self.drawingData = drawingData
    }
}
