//
//  WordLearningViewModel.swift
//  Totori
//
//  Created by 복지희 on 2/25/26.
//

import Combine
import Foundation

// MARK: - Model

struct WordItem: Identifiable, Equatable {
    let id = UUID()
    let text: String
}

// MARK: - ViewModel

final class WordLearningViewModel: ObservableObject {

    // chip
    @Published var userName: String = "김밤톨"
    @Published var profileUrl: String = "https://picsum.photos/100"
    @Published var acornCount: Int = 10

    // progress
    @Published var progress: CGFloat = 0.4

    // wordList
    @Published var words: [WordItem] = [
        .init(text: "응원"),
        .init(text: "당연"),
        .init(text: "긍정"),
        .init(text: "정원")
    ]

    // reward
    @Published var rewardCount: Int = 1
}
