//
//  ReadStoryBookViewModel.swift
//  Totori
//
//  Created by 정윤아 on 3/1/26.
//

import AVFoundation
import Combine
import SwiftUI

class ReadStoryBookViewModel: ObservableObject {
    
    @Published var displayPages: [DisplayPage] = []
    @Published var currentIndex: Int = 0
    
    @Published var isMicRecording: Bool = false
    @Published var isTTSSpeaking: Bool = false
    @Published var isPanelVisible: Bool = true
    
    @Published var navigateToBadge: Bool = false
    @Published var navigateToFinish: Bool = false
    @Published var navigateToQuiz: Bool = false
    @Published var pendingQuizData: QuizResponseDTO? = nil
    
    // 낭독 완료 API 결과
    @Published var completeResult: BookCompleteResponseDTO? = nil
    
    private let audioRecorder = AudioRecorderManager()
    private(set) var lastRecordedURL: URL?
    
    private var audioPlayer: AVPlayer?
    private var playerObserver: Any?
    
    private let bookService = BookService()
    private var cancellables = Set<AnyCancellable>()
    
    private var quizInterval: Int = 18
    private var quizImageCount: Int = 6
    
    private(set) var bookId: Int = 0
    private(set) var coverImageUrl: String = ""
    private var earnedAcornCount: Int = 0
    init() {}
    
    // MARK: - Setup
    
    // ✅ BookGenerateResponseDTO 버전
    func setUpData(bookData: BookGenerateResponseDTO) {
        self.bookId = bookData.bookId
        self.coverImageUrl = bookData.coverImageUrl
        print("📚 bookId 세팅: \(self.bookId)")
        var flatList: [DisplayPage] = []
        var globalIdx = 0
        
        let sortedPages = bookData.pages.sorted { $0.pageOrder < $1.pageOrder }
        
        
        for page in sortedPages {
            for sentence in page.sentences {
                flatList.append(DisplayPage(
                    globalIndex: globalIdx,
                    imageUrl: page.imageUrl,
                    text: sentence.text,
                    audioUrl: sentence.audioUrl
                ))
                globalIdx += 1
            }
        }
        self.displayPages = flatList
        configureQuizInterval()
    }
    
    func setUpData(bookDetail: BookDetailResponseDTO) {
        self.bookId = bookDetail.cover.bookId
        print("📚 bookId 세팅: \(self.bookId)")
        self.coverImageUrl = bookDetail.cover.coverImageUrl
        var flatList: [DisplayPage] = []
        var globalIdx = 0
        
        for page in bookDetail.pages.sorted(by: { $0.pageOrder < $1.pageOrder }) {
            for sentence in page.sentences {
                flatList.append(DisplayPage(
                    globalIndex: globalIdx,
                    imageUrl: page.imageUrl,
                    text: sentence.text,
                    audioUrl: sentence.audioUrl
                ))
                globalIdx += 1
            }
        }
        self.displayPages = flatList
        configureQuizInterval()
    }
    
    private func configureQuizInterval() {
        quizInterval = displayPages.count <= 18 ? 6 : 9
        print("📝 퀴즈 간격: \(quizInterval) pages (총 \(displayPages.count)페이지)")
    }
    
    // MARK: - Computed Properties
    
    var currentDisplayPage: DisplayPage {
        guard !displayPages.isEmpty else {
            return DisplayPage(globalIndex: 0, imageUrl: "", text: "", audioUrl: "")
        }
        let safeIndex = min(max(currentIndex, 0), displayPages.count - 1)
        return displayPages[safeIndex]
    }
    
    var progress: CGFloat {
        guard !displayPages.isEmpty else { return 0 }
        return CGFloat(currentIndex + 1) / CGFloat(displayPages.count)
    }
    
    var centerControlType: CenterControlType {
        return isMicRecording ? .micRinging : .mic
    }
    
    var isPrevEnabled: Bool { currentIndex > 0 }
    var isNextEnabled: Bool { !displayPages.isEmpty }
    
    // MARK: - Navigation
    
    func goNext() {
        if isMicRecording {
            stopRecordingFlow()
        }
        
        if currentIndex < displayPages.count - 1 {
            withAnimation { currentIndex += 1 }
            resetPageStates()
            checkQuizTrigger()
        } else {
            // 마지막 페이지 → 낭독 완료 API 호출
            completeReading()
        }
    }
    
    func goPrev() {
        guard isPrevEnabled else { return }
        
        if isMicRecording {
            stopRecordingFlow()
        }
        
        withAnimation { currentIndex -= 1 }
        resetPageStates()
    }
    
    // MARK: - Quiz Trigger
    
    private func checkQuizTrigger() {
        let oneBased = currentIndex + 1
        guard oneBased % quizInterval == 0 else { return }
        print("🎯 퀴즈 트리거! page index: \(currentIndex)")
        navigateToQuiz = true
    }
    
    // MARK: - 낭독 완료 API
    
    private func completeReading() {
        print("📡 동화 낭독 완료 API 호출 - bookId: \(bookId), acornCount: \(earnedAcornCount)")
        
        bookService.completeBook(bookId: bookId, acornCount: earnedAcornCount)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("❌ 낭독 완료 API 실패: \(error)")
                        // API 실패해도 완료 화면으로 이동
                        self.navigateToFinish = true
                    }
                },
                receiveValue: { [weak self] result in
                    guard let self else { return }
                    print("✅ 낭독 완료 - bookId: \(result.bookId), acorn: \(result.acornCount), totalAcorn: \(result.totalReceivedAcorn)")
                    self.completeResult = result
                    
                    if !result.newlyAcquiredBadges.isEmpty {
                        print("🏅 새로운 뱃지 \(result.newlyAcquiredBadges.count)개 획득!")
                        self.navigateToBadge = true
                    } else {
                        print("📖 완독 화면으로 이동")
                        self.navigateToFinish = true
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - TTS
    
    func toggleMic() {
        if isMicRecording {
            stopRecordingFlow()
        } else {
            startRecordingFlow()
        }
    }
    
    func toggleTTS() {
        if isTTSSpeaking {
            stopAudio()
            return
        }
        
        guard let urlString = currentDisplayPage.audioUrl,
              let url = URL(string: urlString) else {
            print("❌ 유효한 오디오 URL이 없습니다.")
            return
        }
        
        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer?.play()
        isTTSSpeaking = true
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            self?.isTTSSpeaking = false
        }
    }
    
    private func stopAudio() {
        audioPlayer?.pause()
        audioPlayer = nil
        isTTSSpeaking = false
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    // MARK: - Recording Flow
    
    private func startRecordingFlow() {
        if isTTSSpeaking {
            withAnimation { isTTSSpeaking = false }
        }
        
        audioRecorder.requestPermission { [weak self] granted in
            guard let self = self else { return }
            if granted {
                self.audioRecorder.startRecoding()
                withAnimation { self.isMicRecording = true }
            } else {
                print("마이크 권한 거부됨")
            }
        }
    }
    
    private func stopRecordingFlow() {
        let savedURL = audioRecorder.stopRecording()
        self.lastRecordedURL = savedURL
        withAnimation { self.isMicRecording = false }
        
        if let url = savedURL {
            handleRecordedAudio(url: url)
        }
    }
    
    private func handleRecordedAudio(url: URL) {
        let sentenceNum = currentDisplayPage.globalIndex
        
        bookService.uploadReadingAudio(bookId: bookId, sentenceNum: sentenceNum, audioURL: url)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("❌ 업로드 실패: \(error)")
                    }
                },
                receiveValue: { _ in
                    print("✅ 녹음 업로드 완료 (sentenceNum: \(sentenceNum))")
                }
            )
            .store(in: &cancellables)
    }
    
    private func resetPageStates() {
        isMicRecording = false
        stopAudio()
    }
    
    func togglePanel() { withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { isPanelVisible.toggle() } }
    
    private func checkBadgeCompletion() {
        print("API Request: 뱃지 획득 여부 확인 중...")
        let isBadgeEarned = Bool.random()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if isBadgeEarned {
                print("결과: 뱃지 획득!")
                self.navigateToBadge = true
            } else {
                print("결과: 획득한 뱃지 없음 (완독 화면으로)")
                self.navigateToFinish = true
            }
        }
    }
}
