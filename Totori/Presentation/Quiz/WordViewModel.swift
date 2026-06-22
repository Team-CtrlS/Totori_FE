//
//  WordViewModel.swift
//  Totori
//
//  Created by 복지희 on 2/25/26.
//

import AVFoundation
import Combine
import Foundation

final class WordViewModel: ObservableObject {

    // chip
    @Published var userName: String = "김밤톨"
    @Published var profileUrl: String = ""
    @Published var acornCount: Int = 11

    // progress
    @Published var progress: CGFloat = 0.4

    // reward
    @Published var rewardCount: Int = 1

    // MARK: - Word list
    
    @Published var words: [String] = []
    @Published var audioUrls: [String] = []
    private var audioPlayer: AVPlayer?

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
                    self.audioUrls = quizData.audioUrls
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
    
    // MARK: - TTS

    // 변경 후 — Combine 방식
    func playAudio(for word: String) {
        audioPlayer?.pause()
        audioPlayer = nil
        
        guard let index = words.firstIndex(of: word),
              index < audioUrls.count,
              let url = URL(string: audioUrls[index]) else {
            print("❌ 오디오 URL을 찾을 수 없습니다: \(word)")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("❌ 오디오 세션 설정 실패: \(error)")
        }

        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer?.volume = 1.0

        // 상태 관찰 — 로드 실패 원인 확인용
        playerItem.publisher(for: \.status)
            .sink { status in
                switch status {
                case .readyToPlay:
                    print("✅ 오디오 준비 완료: \(word)")
                case .failed:
                    print("❌ 오디오 로드 실패: \(playerItem.error?.localizedDescription ?? "unknown")")
                default:
                    break
                }
            }
            .store(in: &cancellables)

        audioPlayer?.play()
        print("🔊 TTS 재생 시도: \(word)")
    }

    func stopAudio() {
        audioPlayer?.pause()
        audioPlayer = nil
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

    // 퀴즈 완료 후 낭독 화면으로 복귀
    func completeQuiz() {
        isShowingQuizModal = false
        onQuizCompleted?()
    }
}
