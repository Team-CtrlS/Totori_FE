//
//  BookInfoViewModel.swift
//  Totori
//
//  Created by 정윤아 on 2/28/26.
//

import Combine
import SwiftUI

class BookInfoViewModel: ObservableObject {
    
    // MARK: - Published
    
    @Published var bookTitle: String = ""
    @Published var coverImageUrl: String = ""
    @Published var totalPages: Int = 0
    @Published var readPages: Int = 0
    @Published var acornCount: Int = 0
    @Published var navigateToReadStoryBook: Bool = false
    @Published var readSource: ReadStoryBookSource? = nil
    
    // MARK: - Data Source
    
    private var generatedBookData: BookGenerateResponseDTO? = nil
    private var detailBookData: BookDetailResponseDTO? = nil
    
    // MARK: - Computed
    
    var progressPercentage: Double {
        guard totalPages > 0 else { return 0.0 }
        return Double(readPages) / Double(totalPages)
    }
    
    var progressText: String {
        return "\(readPages)/\(totalPages)"
    }
    
    // MARK: - Set up
    
    func setupData(with data: BookGenerateResponseDTO) {
        generatedBookData = data
        bookTitle = data.title
        coverImageUrl = data.coverImageUrl
        totalPages = data.pages.count
        readPages = 0
        acornCount = 0
        readSource = .generated(data)
    }
    
    func fetchDetail(bookId: Int) {
        bookDetailService.fetchBookDetail(bookId: bookId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("❌ 실패: \(error)")
                case .finished:
                    print("✅ 완료")
                }
            } receiveValue: { [weak self] response in
                self?.applyDetailData(response)
            }
            .store(in: &cancellables)
    }
    
    private func applyDetailData(_ data: BookDetailResponseDTO) {
        detailBookData = data
        bookTitle = data.cover.title
        coverImageUrl = data.cover.coverImageUrl
        totalPages = data.cover.totalPage
        readPages = data.cover.currentPage
        acornCount = data.cover.acornCount
        readSource = .detail(data)
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
        navigateToReadStoryBook = true
    }
    
    // MARK: - Private
    
    private var cancellables = Set<AnyCancellable>()
    private let bookDetailService = BookDetailService()
}
