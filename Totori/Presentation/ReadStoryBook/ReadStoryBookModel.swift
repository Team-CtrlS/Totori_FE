//
//  ReadStoryBookModel.swift
//  Totori
//
//  Created by 정윤아 on 3/1/26.
//

import SwiftUI

struct StoryBookData {
    let title: String
    let scenes: [StoryScene]
}

struct StoryScene {
    let sceneNumber: Int
    let imageUrl: String
    let pages: [ScenePage]
}

struct ScenePage {
    let pageNumber: Int
    let text: String
}

struct DisplayPage {
    let globalIndex: Int
    let imageUrl: String
    let text: String
}
