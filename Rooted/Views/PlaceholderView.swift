//
//  PlaceholderView.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//
import SwiftUI

struct PlaceholderView: View {
    var text: String? = nil
    
    var body: some View {
        VStack {
            Image(systemName: "hand.tap")
                .resizable()
                .frame(width: 100, height: 100)
            Text("\(text ?? "Select an Option")")
                .font(.title2)
        }
        .opacity(0.25)
    }
}
