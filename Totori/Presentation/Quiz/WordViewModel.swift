//
//  WordViewModel.swift
//  Totori
//
//  Created by 복지희 on 2/25/26.
//

import Combine
import Foundation

final class WordViewModel: ObservableObject {

    // chip
    @Published var userName: String = "김밤톨"
    @Published var profileUrl: String = "https://picsum.photos/100"
    @Published var acornCount: Int = 10

    // progress
    @Published var progress: CGFloat = 0.4

    // reward
    @Published var rewardCount: Int = 1

    // MARK: - Word list
    @Published var words: [String] = []

    // MARK: - Quiz State
    @Published var currentIndex: Int = 0
    @Published var stage: WordQuizStage = .mic
    @Published var isShowingQuizModal: Bool = false
    @Published var isFinished: Bool = false

    // MARK: - API State
    @Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil

    private(set) var quizId: Int = 0
    private let bookId: Int

    private let quizService = QuizService()
    private let audioRecorder = AudioRecorderManager()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(bookId: Int) {
        self.bookId = bookId
    }

    // MARK: - Computed

    var currentWord: String {
        guard !words.isEmpty, currentIndex < words.count else { return "" }
        return words[currentIndex]
    }

    // MARK: - API

    func fetchQuiz() {
        isLoading = true
        errorMessage = nil
        print("📡 퀴즈 API 호출 시작 (bookId: \(bookId))")

        quizService.makeQuiz(bookId: bookId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    self.isLoading = false
                    if case .failure(let error) = completion {
                        print("❌ 퀴즈 API 실패: \(error)")
                        self.errorMessage = "퀴즈를 불러오지 못했어요"
                    }
                },
                receiveValue: { [weak self] quizData in
                    guard let self else { return }
                    self.isLoading = false
                    self.quizId = quizData.quizId
                    self.words = quizData.quizItems
                    self.currentIndex = 0
                    self.stage = .mic
                    self.isFinished = false
                    print("✅ 퀴즈 데이터 수신: quizId=\(quizData.quizId), words=\(quizData.quizItems)")
                }
            )
            .store(in: &cancellables)
    }

    // MARK: - Quiz Logic

    func setupQuiz() {
        words.shuffle()
        currentIndex = 0
        stage = .mic
        isFinished = false
    }

    func handleMicAction() {
        switch stage {
        case .mic:
            startRecording()
        case .speaking:
            stopRecordingAndCheck()
        case .fail:
            retryCurrentWord()
        case .success:
            break
        }
    }

    private func startRecording() {
        audioRecorder.requestPermission { [weak self] granted in
            guard let self else { return }
            if granted {
                self.audioRecorder.startRecoding()
                self.stage = .speaking
                print("🎙️ 퀴즈 녹음 시작 - 단어: \(self.currentWord)")
            } else {
                print("❌ 마이크 권한 거부됨")
            }
        }
    }
    
    private func stopRecordingAndCheck() {
          let savedURL = audioRecorder.stopRecording()
          print("🛑 퀴즈 녹음 종료")
   
          if let url = savedURL {
              // TODO: 녹음 파일을 서버에 전송하여 정답 판정 받기
              // 현재는 임시로 랜덤 판정
              print("📁 녹음 파일: \(url.lastPathComponent)")
              checkAnswer()
          } else {
              print("❌ 녹음 파일 저장 실패")
              stage = .fail
          }
      }

    private func checkAnswer() {
        print("STT 결과 판정 중...")
        // TODO: 서버 정답 판정 API 연결
        let isCorrect = Bool.random()
 
        if isCorrect {
            stage = .success
            print("✅ 정답!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.moveToNextWord()
            }
        } else {
            stage = .fail
            isShowingQuizModal = true
            print("❌ 오답!")
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
