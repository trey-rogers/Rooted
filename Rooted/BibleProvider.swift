//
//  BibleProvider.swift
//  Rooted
//
//  Created by Trey Rogers on 9/30/25.
//
import Foundation
import SwiftData

final class BibleProvider {
    static func loadData(context: ModelContext) {
        let fetch = FetchDescriptor<Book>()
        if let existing = try? context.fetch(fetch), !existing.isEmpty {
            return // Already imported
        }

        guard let url = Bundle.main.url(forResource: "asv", withExtension: "json") else {
            fatalError("Could not find asv.json in bundle")
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let bible = try decoder.decode(Bible.self, from: data)

            for bookDTO in bible.books {
                let book = bookDTO.toModel()
                context.insert(book)
            }

            try context.save()
        } catch {
            fatalError("Error decoding or saving JSON: \(error)")
        }
    }
}

