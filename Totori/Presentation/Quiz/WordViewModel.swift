//
//  WordViewModel.swift
//  Totori
//
//  Created by 복지희 on 2/25/26.
//

import Combine
import Foundation

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
    @Published var words: [String] = [ "응원", "당연", "긍정", "정원" ]
    
    // MARK: - Quiz State
    @Published var currentIndex: Int = 0
    @Published var stage: WordQuizStage = .mic
    @Published var isShowingQuizModal: Bool = false
    @Published var isFinished: Bool = false

    // 현재 학습 중인 단어
    var currentWord: String {
        guard !words.isEmpty && currentIndex < words.count else { return "" }
        return words[currentIndex]
    }

    // MARK: - Logic

    func setupQuiz() {
        self.words.shuffle()
        self.currentIndex = 0
        self.stage = .mic
        self.isFinished = false
    }
    
    func handleMicAction() {
        switch stage {
        case .mic:
            startSpeaking()
        case .speaking:
            checkAnswer()
        case .fail:
            retryCurrentWord()
        case .success:
            break
        }
    }
    
    private func startSpeaking() {
        stage = .speaking
        // TODO: 녹음 기능으로 변경
        print("STT 시작")
    }
    
    private func checkAnswer() {
        // TODO: 정답여부 결과값 받아오기(일단 임시로 랜덤 설정)
        print("STT 종료 및 결과 판정")
        let isCorrect = Bool.random()
        
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
