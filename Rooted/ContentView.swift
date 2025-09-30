//
//  ContentView.swift
//  Rooted
//
//  Created by Trey Rogers on 9/29/25.
//

import SwiftUI

struct ContentView: View {
    let bible: Bible = loadJSON(filename: "asv", type: Bible.self)
    var bookNamesList: String { bible.books.map { $0.name }.joined(separator: ", ") }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world! \(bookNamesList)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T {
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
