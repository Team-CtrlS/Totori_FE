//
//  BookInfoViewModel.swift
//  Totori
//
//  Created by 정윤아 on 2/28/26.
//

import Combine
import SwiftUI

class BookInfoViewModel: ObservableObject {
    @Published var bookData: BookGenerateResponseDTO? = nil
    
    @Published var bookTitle: String = ""
    @Published var coverImageUrl: String = ""
    @Published var totalPages: Int = 0
    @Published var readPages: Int = 0
    @Published var acornCount: Int = 0
    
    @Published var navigateToReadStoryBook: Bool = false
    
    var progressPercentage: Double {
        guard totalPages > 0 else { return 0.0 }
        return Double(readPages) / Double(totalPages)
    }
    
    var progressText: String {
        return "\(readPages)/\(totalPages)"
    }
    
    // MARK: - Actions
    
    func setupData(with data: BookGenerateResponseDTO) {
        self.bookData = data
        self.bookTitle = data.title
        
        self.coverImageUrl = data.coverImageUrl
        self.totalPages = data.pages.count
        self.readPages = 0
    }
    
    func tapBackButton() {
        print("뒤로 가기 버튼 탭")
    }
    
    func tapOptionButton() {
        print("옵션 버튼 탭")
    }
    
    func tapReadStory() {
        print("이야기 읽기 버튼 탭")
        navigateToReadStoryBook = true
    }
}
