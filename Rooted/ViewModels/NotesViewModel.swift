//
//  NotesViewModel.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//

import SwiftUI
import Observation

@Observable
class NotesViewModel {
    var text: String = ""
    var isExpanded: Bool = true
}
