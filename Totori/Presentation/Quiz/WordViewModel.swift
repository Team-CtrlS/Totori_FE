//
//  WordViewModel.swift
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

final class WordViewModel: ObservableObject {

    // chip
    @Published var userName: String = "김밤톨"
    @Published var profileUrl: String = "https://picsum.photos/100"
    @Published var acornCount: Int = 10

    // progress
    @Published var progress: CGFloat = 0.4
    
    // reward
    @Published var rewardCount: Int = 1

    // wordList
    @Published var words: [WordItem] = [
        .init(text: "응원"),
        .init(text: "당연"),
        .init(text: "긍정"),
        .init(text: "정원")
    ]
    
    // MARK: - Quiz State
    @Published var currentIndex: Int = 0
    @Published var stage: WordQuizStage = .mic
    @Published var isShowingQuizModal: Bool = false
    @Published var isFinished: Bool = false // TODO: 4개 단어 모두 끝났을 때 true (모달 띄워야함)

    // 현재 학습 중인 단어
    var currentWord: String {
        guard !words.isEmpty && currentIndex < words.count else { return "" }
        return words[currentIndex].text
    }

    // MARK: - Logic
    
    //TODO: 삭제!!!!!!
    init() {
        setupQuiz()
    }
    
    // 퀴즈 초기 세팅
    func setupQuiz() {
        self.words.shuffle()
        self.currentIndex = 0
        self.stage = .mic
        self.isFinished = false
    }
        
    // 정답 판정
    func checkAnswer(isCorrect: Bool) {
        if isCorrect {
            stage = .success
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.moveToNextWord()
            }
        } else {
            stage = .fail
            isShowingQuizModal = true
        }
    }

    func moveToNextWord() {
        if currentIndex < words.count - 1 {
            currentIndex += 1
            stage = .mic
        } else {
            isFinished = true
            isShowingQuizModal = true
        }
    }

    func retryCurrentWord() {
        stage = .mic
        isShowingQuizModal = false
    }
}
