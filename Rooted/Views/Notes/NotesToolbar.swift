//
//  NotesToolbar.swift
//  Rooted
//
//  Created by Trey Rogers on 10/3/25.
//
import SwiftUI

// MARK: - NotesToolbar
struct NotesToolbar: ToolbarContent {
    @Binding var isExpanded: Bool
    @Binding var isDrawSheetPresented: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                isExpanded.toggle()
            } label: {
                Image(systemName: isExpanded ? "list.clipboard" : "list.clipboard.fill")
                    .font(.title2)
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                isDrawSheetPresented = true
            } label: {
                Image(systemName: "pencil.line")
                    .font(.title2)
            }
        }
    }
}
