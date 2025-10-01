//
//  BibleProvider.swift
//  Rooted
//
//  Created by Trey Rogers on 9/30/25.
//
import Foundation

final class BibleProvider {
    static let shared = BibleProvider.loadJSON(filename: "asv", type: Bible.self)
    static func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            fatalError("Could not find \(filename).json in bundle")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Error decoding \(filename).json: \(error)")
        }
    }

}
