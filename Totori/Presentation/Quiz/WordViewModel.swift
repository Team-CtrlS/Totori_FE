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
    @Published var isChecking: Bool = false

    /// 퀴즈 완료 시 호출할 콜백
    var onQuizCompleted: (() -> Void)?

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

    // MARK: - Recording

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

        guard let audioURL = savedURL else {
            print("❌ 녹음 파일 저장 실패")
            stage = .fail
            return
        }

        print("📁 녹음 파일: \(audioURL.lastPathComponent)")
        submitQuizAudio(audioURL: audioURL)
    }

    // MARK: - Quiz Check API

    private func submitQuizAudio(audioURL: URL) {
        let originalQuiz = currentWord
        isChecking = true
        print("📡 퀴즈 채점 API 호출 - quizId: \(quizId), 원본: \(originalQuiz)")

        quizService.checkQuiz(quizId: quizId, audioURL: audioURL, originalQuiz: originalQuiz)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    self.isChecking = false
                    if case .failure(let error) = completion {
                        print("❌ 퀴즈 채점 API 실패: \(error)")
                        self.stage = .fail
                        self.isShowingQuizModal = true
                    }
                },
                receiveValue: { [weak self] result in
                    guard let self else { return }
                    self.isChecking = false
                    print("✅ 퀴즈 채점 결과 - isCorrect: \(result.isCorrect), rewarded: \(result.rewarded), acorn: \(result.currentAcorn)")

                    if result.isCorrect {
                        self.stage = .success
                        print("🎉 정답!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.moveToNextWord()
                        }
                    } else {
                        self.stage = .fail
                        self.isShowingQuizModal = true
                        print("😢 오답!")
                    }
                }
            )
            .store(in: &cancellables)
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

    /// 퀴즈 완료 후 낭독 화면으로 복귀
    func completeQuiz() {
        isShowingQuizModal = false
        onQuizCompleted?()
    }
}
