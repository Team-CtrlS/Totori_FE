//
//  BookInfoViewModel.swift
//  Totori
//
//  Created by 정윤아 on 2/28/26.
//

import Combine
import SwiftUI

class BookInfoViewModel: ObservableObject {
    
    @Published var bookTitle: String = "도토리 숲의 비밀 모험"
    @Published var coverImageName: String? = nil
    @Published var totalPages: Int = 12
    @Published var readPages: Int = 3
    @Published var acornCount: Int = 2
    
    var progressPercentage: Double {
        return Double(readPages) / Double(totalPages)
    }
    
    var progressText: String {
        return "\(readPages)/\(totalPages)"
    }
    
    // MARK: - Actions
    
    func tapBackButton() {
        print("뒤로 가기 버튼 탭")
    }
    
    func tapOptionButton() {
        print("옵션 버튼 탭")
    }
    
    func tapReadStory() {
        print("이야기 읽기 버튼 탭")
    }
}
