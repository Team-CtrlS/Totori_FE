//
//  MainViewModel.swift
//  Totori
//
//  Created by 정윤아 on 2/24/26.
//

import Combine
import Foundation

// MARK: - Model

struct FeaturedBook {
    let coverURL: String?
    let title: String
    let subtitle: String
    let rewardCount: Int
    let progress: Double
    let currentPage: Int
    let totalPage: Int
}

struct BookList: Identifiable {
    let id: Int
    let title: String
    let coverURL: String?
    let progress: Double
    let hasBadge: Bool
    let type: BookType
}

// MARK: - ViewModel

class MainViewModel: ObservableObject {
    // chip
    @Published var userName: String = ""
    @Published var userImage: String? = nil
    @Published var acornCount: Int = 0
    
    // badgeCard
    @Published var goalTitle: String = "도토리 수집가"
    @Published var goalSubtitle: String = "도토리 총 10개 모으기 (4/10)"
    @Published var goalProgress: Double = 0.4
    @Published var goalImageURL: String? = nil
    @Published var hasBadge: Bool = false
    
    // bookList
    @Published var bookItems: [BookList] = []
    @Published var currentPage: Int = 0
    @Published var isLastPage: Bool = false
    private let pageSize: Int = 5
    
    // recentBook
    @Published var featuredBook = FeaturedBook(
        coverURL: nil,
        title: "아직 읽은 동화가 없어요",
        subtitle: "목표 달성까지 얼마 안 남았어!",
        rewardCount: 0,
        progress: 0,
        currentPage: 0,
        totalPage: 0
    )
    @Published var hasCurrentBook: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let mainStatusService = MainStatusService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchAll() {
        fetchMainStatus()
        fetchBookList(reset: true)
    }
    
    func fetchBookList(reset: Bool = false) {
        let pageToFetch = reset ? 0 : currentPage
        
        mainStatusService.fetchBookList(page: pageToFetch, size: pageSize)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    Logger.error(.network, "동화 목록 조회 실패: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                let newItems = response.books.map { self.mapToBookItem($0) }
                
                if reset {
                    self.bookItems = newItems
                    self.currentPage = 1
                } else {
                    self.bookItems.append(contentsOf: newItems)
                    self.currentPage += 1
                }
                
                self.isLastPage = response.isLast
            }
            .store(in: &cancellables)
    }
    
    func fetchNextPage() {
        guard !isLastPage else { return }
        fetchBookList(reset: false)
    }
    
    private func mapToBookItem(_ dto: BookSummaryDTO) -> BookList {
        let coverURL: URL? = dto.coverImageUrl.flatMap { URL(string: $0) }
        let type: BookType
        
        if dto.progress <= 0.0 {
            type = .unread(title: dto.title, cover: coverURL, purpleBackground: false)
        } else if dto.progress >= 1.0 {
            type = .finished(title: dto.title, cover: coverURL, purpleBackground: false)
        } else {
            type = .reading(title: dto.title, cover: coverURL, progress: dto.progress)
        }
        
        return BookList(
            id: dto.bookId,
            title: dto.title,
            coverURL: dto.coverImageUrl,
            progress: dto.progress,
            hasBadge: dto.hasBadge,
            type: type
        )
    }
    
    func fetchMainStatus() {
        isLoading = true
        
        mainStatusService.fetchMainStatus()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    Logger.error(.network, "메인 정보 조회 실패: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.applyUserInfo(response.acorn)
                self?.applyCurrentBook(response.currentBook)
                self?.applyBadge(response.badge)
            }
            .store(in: &cancellables)
    }
    
    private func applyUserInfo(_ acornData: AcornDTO?) {
        guard let data = acornData else { return }
        self.userName = data.name
        self.acornCount = data.acorn
    }
    
    private func applyCurrentBook(_ book: CurrentBookDTO?) {
        guard let book = book else {
            hasCurrentBook = false
            return
        }
        
        hasCurrentBook = true
        featuredBook = FeaturedBook(
            coverURL: book.coverImageUrl,
            title: book.title,
            subtitle: "목표 달성까지 얼마 안남았어!",
            rewardCount: book.acornCount,
            progress: book.progressPercentage,
            currentPage: book.currentPage,
            totalPage: book.totalPage
        )
    }
    
    private func applyBadge(_ badge: MemberBadgeResponseDTO?) {
        guard let badge = badge else {
            hasBadge = false
            goalTitle = "아직 획득한 뱃지가 없어요"
            goalSubtitle = "동화를 읽고 뱃지를 모아봐요"
            goalProgress = 0.0
            return
        }
        
        let badgeInfo = badge.badgeResponseDto
        
        hasBadge = true
        goalTitle = badgeInfo.categoryName
        
        let current = badgeInfo.targetValue
        let total = badgeInfo.targetValue
        
        goalSubtitle = "\(badgeInfo.name) (\(current)/\(total))"
        goalProgress = total > 0 ? Double(current) / Double(total) : 0.0
        goalImageURL = badgeInfo.imageUrl
    }
}
