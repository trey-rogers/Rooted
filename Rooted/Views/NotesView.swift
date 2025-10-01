//
//  BooksSidebarView.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//
import SwiftUI

struct NotesView: View {
    @Bindable var viewModel: NotesViewModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if viewModel.isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Button { viewModel.isExpanded.toggle() } label: {
                            Image(systemName: "chevron.right")
                        }
                        Text("Notes").font(.headline)
                    }
                    TextEditor(text: $viewModel.text)
                        .frame(minHeight: 200)
                        .border(Color.secondary)
                }
                .padding()
            } else {
                VStack {
                    Button { viewModel.isExpanded.toggle() } label: {
                        Image(systemName: "chevron.left")
                            .padding(.top, 8)
                    }
                    Spacer()
                }
            }
        }
        .frame(width: viewModel.isExpanded ? 250 : 32)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isExpanded)
    }
}
