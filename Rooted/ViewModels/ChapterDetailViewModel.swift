//
//  ChapterDetailViewModel.swift
//  Rooted
//
//  Created by Trey Rogers on 10/1/25.
//

import SwiftUI
import Observation

@Observable
class ChapterDetailViewModel {
    var chapter: Chapter
    init(chapter: Chapter) {
        self.chapter = chapter
    }
}
