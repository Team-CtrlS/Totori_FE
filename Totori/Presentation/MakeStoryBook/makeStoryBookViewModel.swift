//
//  makeStoryBookViewModel.swift
//  Totori
//
//  Created by 정윤아 on 2/27/26.
//

import Combine
import SwiftUI

enum GenerationStep: Int, CaseIterable {
    case acorn = 0
    case speak = 1
    case listening = 2
    case processing = 3
    
    func chatMessage(userName: String) -> String {
        switch self {
        case .acorn:
            return "이야기를 만들기 위해선\n도토리가 필요해, \(userName)!"
        case .speak, .listening:
            return "\(userName). 안녕!\n오늘은 무슨 이야기를 해볼래?"
        case .processing:
            return "조금만 기다려 줘.\n새로운 이야기를 만들고 있어!"
        }
    }
    
    var chatIcon: Image {
        switch self {
        case .listening:
            return Image(.retryPink)
        default:
            return Image(.soundWavePink1)
        }
    }
}

class makeStoryBookViewModel: ObservableObject {
    @Published var currentStep: GenerationStep = .acorn
    @Published var userName: String = "김밤톨"
    @Published var userImage: String? = nil
    @Published var acornCount: Int = 1
    
    @Published var isRecording: Bool = false
    
    var currentCenterType: CenterType {
        switch currentStep {
        case .acorn: return .acorn
        case .speak: return .speak
        case .listening: return .listening(isRecording: isRecording)
        case .processing: return .processing
        }
    }
    
    func goNextStep() {
        let allSteps = GenerationStep.allCases
        guard let currentIndex = allSteps.firstIndex(of: currentStep) else { return }
        if currentIndex < allSteps.count - 1 {
            currentStep = allSteps[currentIndex + 1]
        }
    }
    
    func goPrevStep() {
        let allSteps = GenerationStep.allCases
        guard let currentIndex = allSteps.firstIndex(of: currentStep) else { return }
        if currentIndex > 0 {
            currentStep = allSteps[currentIndex - 1]
        }
    }
    
    func performCenterAction() {
        switch currentStep {
        case .acorn:
            print("🌰 도토리 소모 및 동화 생성 API 호출 준비")
            // TODO: TTS 재생 완료 후 아래 코드로 스텝 전환
            if acornCount >= 1 {
                acornCount -= 1
                withAnimation { currentStep = .speak }
            } else {
                print("도토리 부족")
            }
            
        case .speak:
            print("🔊 TTS 재생 및 마이크 켜기 API 준비")
            // TODO: 서버에 음성 데이터 보내고 응답받으면 아래 코드로 스텝 전환
            withAnimation { currentStep = .listening }
            
        case .listening:
            if !isRecording {
                print("🎙️ 첫 번째 탭: 녹음 시작")
                withAnimation { isRecording = true }
            } else {
                print("🎙️ 두 번째 탭: 녹음 중지 및 STT(음성->텍스트) API 전송 준비")
                withAnimation { isRecording = false }
                withAnimation { currentStep = .processing }
            }
            
        case .processing:
            break
        }
    }
}
