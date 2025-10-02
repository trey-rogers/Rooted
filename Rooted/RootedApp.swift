//
//  RootedApp.swift
//  Rooted
//
//  Created by Trey Rogers on 9/29/25.
//

import SwiftUI
import SwiftData

@main
struct RootedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Book.self, Chapter.self, Verse.self])
    }
}
