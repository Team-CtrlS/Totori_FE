//
//  MainViewModel.swift
//  Totori
//
//  Created by 정윤아 on 2/24/26.
//

import Combine
import Foundation

final class MainViewModel: ObservableObject {
    
    struct State {
        var profileName: String = "김밤톨"
        var profileImageURL: String? = nil
        var acornAmount: Int = 5
        
        var collectorTItle: String = "도토리 수집가"
        var collectorSubtitle: String = "도토리 총 10개 모으기 (4/10)"
        var collectorProgress: Double = 0.4
        
        var books: [BookType] = []
    }
    
    enum Action {
        case tapProfile
        case tapTrophy
        case tapAcorn
        case tapQuestion
        
        case tapCollector
        case tapBook(BookType)
    }
    
    @Published private(set) var state: State = .init()
    
    init() {
        loadMock()
    }
    
    func send(_ action: Action) {
        switch action {
        case .tapProfile:
            print("tapProfile")
        case .tapTrophy:
            print("tapTrophy")
        case .tapAcorn:
            print("tapAcorn")
        case .tapQuestion:
            print("tapQuestion")
            
        case .tapCollector:
            print("tapCollector")
        case .tapBook:
            print("tapBook")
        }
    }
    
    private func loadMock() {
        state.books = [
            .create(title: "이야기 시작하기"),
            .unread(title: "도토리 숲의 비밀 모험", cover: nil, purpleBackground: false),
            .unread(title: "도토리 숲의 비밀 모험", cover: nil, purpleBackground: false),
            .finished(title: "도토리 숲의 비밀 모험", cover: nil, purpleBackground: true)
        ]
    }
}
