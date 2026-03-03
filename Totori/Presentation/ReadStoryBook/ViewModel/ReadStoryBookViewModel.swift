//
//  ReadStoryBookViewModel.swift
//  Totori
//
//  Created by 정윤아 on 3/1/26.
//

import Combine
import SwiftUI

class ReadStoryBookViewModel: ObservableObject {
    
    @Published var displayPages: [DisplayPage] = []
    @Published var currentIndex: Int = 0
    
    @Published var isMicRecording: Bool = false
    @Published var isTTSSpeaking: Bool = false
    @Published var isPanelVisible: Bool = true
    
    init() {
        loadData()
    }
    
    private func loadData() {
        let rawData = StoryBookData(
            title: "거북이와 토끼의 모험",
            scenes: [
                StoryScene(sceneNumber: 1, imageUrl: "https://picsum.photos/id/10/800/1200", pages: [
                    ScenePage(pageNumber: 1, text: "포근한 가을날, 도토리 숲 속에 작은 다람쥐 한 마리가 살고 있었어요."),
                    ScenePage(pageNumber: 2, text: "숲에는 커다란 나무가 많았다."),
                    ScenePage(pageNumber: 3, text: "햇빛이 나뭇잎 사이로 비췄다."),
                    ScenePage(pageNumber: 4, text: "거북이는 길을 따라 걸어갔다.")
                ]),
                StoryScene(sceneNumber: 2, imageUrl: "https://picsum.photos/id/11/800/1200", pages: [
                    ScenePage(pageNumber: 5, text: "토끼는 연못 옆을 뛰어다녔다."),
                    ScenePage(pageNumber: 6, text: "연못에는 물고기가 헤엄쳤다."),
                    ScenePage(pageNumber: 7, text: "토끼는 물고기를 신기하게 봤다."),
                    ScenePage(pageNumber: 8, text: "거북이와 토끼가 서로 만났다.")
                ]),
                StoryScene(sceneNumber: 3, imageUrl: "https://picsum.photos/id/12/800/1200", pages: [
                    ScenePage(pageNumber: 9, text: "거북이와 토끼는 인사를 나눴다."),
                    ScenePage(pageNumber: 10, text: "둘은 함께 놀기로 했다."),
                    ScenePage(pageNumber: 11, text: "거북이는 느리게 걸었다."),
                    ScenePage(pageNumber: 12, text: "토끼는 빨리 뛰었다.")
                ]),
                StoryScene(sceneNumber: 4, imageUrl: "https://picsum.photos/id/13/800/1200", pages: [
                    ScenePage(pageNumber: 13, text: "둘은 숲에서 경주를 했다."),
                    ScenePage(pageNumber: 14, text: "거북이는 천천히 출발했다."),
                    ScenePage(pageNumber: 15, text: "토끼는 빨리 달렸다."),
                    ScenePage(pageNumber: 16, text: "거북이는 꾸준히 걸어갔다.")
                ]),
                StoryScene(sceneNumber: 5, imageUrl: "https://picsum.photos/id/14/800/1200", pages: [
                    ScenePage(pageNumber: 17, text: "거북이는 결승선에 도착했다."),
                    ScenePage(pageNumber: 18, text: "토끼는 거북이를 응원했다."),
                    ScenePage(pageNumber: 19, text: "둘은 함께 웃었다."),
                    ScenePage(pageNumber: 20, text: "거북이와 토끼는 친구였다."),
                    ScenePage(pageNumber: 21, text: "그들은 즐거운 시간을 보냈다.")
                ])
            ]
        )
        
        //데이터 평탄화
        var flatList: [DisplayPage] = []
        var globalIdx = 0
        
        for scene in rawData.scenes {
            for page in scene.pages {
                let displayPage = DisplayPage(
                    globalIndex: globalIdx,
                    imageUrl: scene.imageUrl,
                    text: page.text
                )
                flatList.append(displayPage)
                globalIdx += 1
            }
        }
        
        self.displayPages = flatList
    }
    
    var currentDisplayPage: DisplayPage {
        guard !displayPages.isEmpty else {
            return DisplayPage(globalIndex: 0, imageUrl: "", text: "")
        }
        let safeIndex = min(max(currentIndex, 0), displayPages.count - 1)
        return displayPages[safeIndex]
    }
    
    var progressRatio: CGFloat {
        guard !displayPages.isEmpty else { return 0 }
        return CGFloat(currentIndex + 1) / CGFloat(displayPages.count)
    }
    
    var centerControlType: CenterControlType {
        return isMicRecording ? .micRinging : .mic
    }
    
    var isPrevEnabled: Bool { currentIndex > 0 }
    var isNextEnabled: Bool { currentIndex < displayPages.count - 1 }
    
    func goNext() {
        if isNextEnabled { withAnimation { currentIndex += 1 }; resetPageStates() }
    }
    func goPrev() {
        if isPrevEnabled { withAnimation { currentIndex -= 1 }; resetPageStates() }
    }
    func toggleMic() { withAnimation { isMicRecording.toggle() } }
    func toggleTTS() { withAnimation { isTTSSpeaking.toggle() } }
    func togglePanel() { withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { isPanelVisible.toggle() } }
    
    private func resetPageStates() {
        isMicRecording = false
        isTTSSpeaking = false
    }
}
