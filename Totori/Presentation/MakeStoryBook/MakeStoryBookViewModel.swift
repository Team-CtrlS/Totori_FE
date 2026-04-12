//
//  MakeStoryBookViewModel.swift
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
    
    var gifFileName: String {
        switch self {
        case .acorn: return "Character_UsingAcorn"
        case .speak: return "Character_standard"
        case .listening: return "Character_Listening"
        case .processing: return "card_animation"
        }
    }
}

class MakeStoryBookViewModel: ObservableObject {
    @Published var currentStep: GenerationStep = .acorn
    @Published var userName: String = "김밤톨"
    @Published var userImage: String? = nil
    @Published var acornCount: Int = 1
    
    @Published var isRecording: Bool = false
    @Published var isLoading: Bool = false
    @Published var navigateToBookInfo: Bool = false
    @Published var generatedBookData: BookGenerateResponseDTO? = nil
    
    private let bookService = BookService()
    private var cancellables = Set<AnyCancellable>()
    
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
                
                requestBookGeneration()
            }
            
        case .processing:
            break
        }
    }
    
    private func requestBookGeneration() {
        guard !isLoading else { return }
        isLoading = true
        
        let mockSTT = "옛날 옛적에 하얀 털을 가진 귀여운 토끼가 살았어요. 토끼는 배가 고파서 엄청 큰 주황색 당근을 찾으러 숲으로 폴짝폴짝 뛰어갔답니다."
        let param = BookGenerateRequestDTO(sttText: mockSTT)
        
        bookService.generateBook(param: param)
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("❌ 동화 생성 실패: \(error)") }
            } receiveValue: { [weak self] response in
                print("✅ 동화 생성 성공! 책 제목: \(response.title)")
                
                self?.generatedBookData = response
                self?.navigateToBookInfo = true
            }
            .store(in: &cancellables)
    }
}
