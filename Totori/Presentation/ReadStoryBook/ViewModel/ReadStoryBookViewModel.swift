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
    
    private var audioPlayer: AVPlayer?
    private var playerObserver: Any?
    
    init() {}
    
    func setUpData(bookData: BookGenerateResponseDTO) {
        var flatList: [DisplayPage] = []
        var globalIdx = 0
        
        let sortedPages = bookData.pages.sorted { $0.pageOrder < $1.pageOrder }
        
        for page in sortedPages {
            for sentence in page.sentences {
                let displayPage = DisplayPage(
                    globalIndex: globalIdx,
                    imageUrl: page.imageUrl,
                    text: sentence.text,
                    audioUrl: sentence.audioUrl
                )
                flatList.append(displayPage)
                globalIdx += 1
            }
        }
        self.displayPages = flatList
    }
    
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
    
    func goNext() {
        if currentIndex < displayPages.count - 1{
            withAnimation { currentIndex += 1 }
            resetPageStates()
        } else {
            checkBadgeCompletion()
        }
    }
    
    func goPrev() {
        if isPrevEnabled {
            withAnimation { currentIndex -= 1 }
            resetPageStates()
        }
    }
    
    func toggleMic() { withAnimation { isMicRecording.toggle() } }
    func toggleTTS() {
        // 이미 재생 중이면 멈춤
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
    
    // 페이지가 넘어갈 때 재생 중인 오디오 강제 종료
    private func resetPageStates() {
        isMicRecording = false
        stopAudio()
    }
    
    func togglePanel() { withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { isPanelVisible.toggle() } }
    
    private func checkBadgeCompletion() {
        // TODO: 서버에 뱃지 획득 확인 API 전송
        print("API Request: 뱃지 획득 여부 확인 중...")
        
        //TODO: 뱃지 획득 API 연결
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
