//
//  BooksSidebarView.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//

import SwiftUI

struct NotesView: View {
    @Bindable var chapter: Chapter
    @State private var isExpanded: Bool = true

    var body: some View {
        ZStack(alignment: .topLeading) {
            if isExpanded {
                VStack {
                    HStack {
                        Text("Notes")
                            .font(.headline)
                        Spacer()
                        Button { isExpanded.toggle() } label: {
                            Image(systemName: "list.clipboard")
                                .tint(.primary)
                        }
                    }
                    TextEditor(text: $chapter.note)
                        .frame(minHeight: 200)
                        .border(Color.secondary)
                }
            } else {
                ZStack {
                    Button { isExpanded.toggle() } label: {
                        Image(systemName: "list.clipboard.fill")
                            .tint(.primary)
                    }
                }
            }
        }
        .frame(width: isExpanded ? 250 : 14)
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }
}
