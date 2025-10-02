//
//  BooksSidebarView.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//
import SwiftUI

struct NotesView: View {
    @Bindable var chapter: Chapter   // <-- directly bind to SwiftData model
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
                .padding()
            } else {
                VStack {
                    Button { isExpanded.toggle() } label: {
                        Image(systemName: "list.clipboard.fill")
                            .tint(.primary)
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .frame(width: isExpanded ? 250 : 36)
        .background(isExpanded ? Color(.secondarySystemBackground) : .clear)
        .cornerRadius(10)
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }
}
