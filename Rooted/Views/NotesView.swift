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
    @State private var isDrawSheetPresented = false

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
                        Button(action: { isDrawSheetPresented = true }) {
                            Image(systemName: "pencil.line")
                                .imageScale(.large)
                                .tint(.primary)
                                .accessibilityLabel("Show Draw Notes")
                        }
                    }
                    TextEditor(text: $chapter.note)
                        .frame(minHeight: 200)
                        .border(Color.secondary)
                }
            } else {
                ZStack {
                    HStack {
                        Button { isExpanded.toggle() } label: {
                            Image(systemName: "list.clipboard.fill")
                                .tint(.primary)
                        }
                        Button(action: { isDrawSheetPresented = true }) {
                            Image(systemName: "pencil.line")
                                .imageScale(.large)
                                .tint(.primary)
                                .accessibilityLabel("Show Draw Notes")
                        }
                    }
                    
                }
            }
        }
        .sheet(isPresented: $isDrawSheetPresented) {
            VStack {}
                .presentationDetents([.fraction(0.85)])
                .presentationSizing(.page)
        }
        .frame(width: isExpanded ? 250 : 14)
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }
}
