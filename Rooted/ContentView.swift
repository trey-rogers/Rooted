//
//  ContentView.swift
//  Rooted
//
//  Created by Trey Rogers on 9/29/25.
//

import SwiftUI

struct ContentView: View {
    let bible: Bible = BibleProvider.shared
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
