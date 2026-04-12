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
    @Published var userName: String = "김밤톨"
    @Published var userImage: String? = nil
    @Published var acornCount: Int = 4
    
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
        
        print("\n======================")
        print("📚 [MainViewModel] 동화 목록 조회 시작 (page: \(pageToFetch), size: \(pageSize))")
        print("======================")
        
        mainStatusService.fetchBookList(page: pageToFetch, size: pageSize)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("❌ [MainViewModel] 동화 목록 조회 실패: \(error.localizedDescription)\n")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                print("📦 [MainViewModel] 동화 목록 응답 수신")
                print("   - books count: \(response.books.count)")
                print("   - totalPages: \(response.totalPages)")
                print("   - totalElements: \(response.totalElements)")
                print("   - isLast: \(response.isLast)")
                
                let newItems = response.books.map { self.mapToBookItem($0) }
                
                if reset {
                    self.bookItems = newItems
                    self.currentPage = 1
                } else {
                    self.bookItems.append(contentsOf: newItems)
                    self.currentPage += 1
                }
                
                self.isLastPage = response.isLast
                
                print("✅ [MainViewModel] bookItems 업데이트 완료 (총 \(self.bookItems.count)개)\n")
            }
            .store(in: &cancellables)
    }
    
    func fetchNextPage() {
          guard !isLastPage else {
              print("ℹ️ [MainViewModel] 마지막 페이지입니다")
              return
          }
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
        print("\n======================")
        print("🏠 [MainViewModel] 메인 정보 조회 시작")
        print("======================")
        isLoading = true
        
        mainStatusService.fetchMainStatus()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    print("✅ [MainViewModel] 메인 정보 조회 완료\n")
                case .failure(let error):
                    print("❌ [MainViewModel] 메인 정보 조회 실패: \(error.localizedDescription)\n")
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                print("📦 [MainViewModel] 응답 수신")
                print("   - currentBook: \(response.currentBook == nil ? "nil ❌" : "있음 ✅")")
                print("   - badge: \(response.badge == nil ? "nil ❌" : "있음 ✅")")
                
                self?.applyCurrentBook(response.currentBook)
                self?.applyBadge(response.badge)
                
                self?.printCurrentState()
            }
            .store(in: &cancellables)
    }
    
    private func applyCurrentBook(_ book: CurrentBookDTO?) {
        guard let book = book else {
            print("📕 [currentBook] nil → hasCurrentBook = false")
            hasCurrentBook = false
            return
        }
        
        print("📕 [currentBook] 파싱 결과:")
        print("   - bookId: \(book.bookId)")
        print("   - title: \(book.title)")
        print("   - coverImageUrl: \(book.coverImageUrl ?? "nil")")
        print("   - acornCount: \(book.acornCount)")
        print("   - currentPage: \(book.currentPage)")
        print("   - totalPage: \(book.totalPage)")
        print("   - progressPercentage: \(book.progressPercentage)")
        
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
            print("🏅 [badge] nil → 기본 메시지 표시")
            hasBadge = false
            goalTitle = "아직 획득한 뱃지가 없어요"
            goalSubtitle = "동화를 읽고 뱃지를 모아봐요"
            goalProgress = 0.0
            return
        }
        
        let badgeInfo = badge.badgeResponseDto
        
        print("🏅 [badge] 파싱 결과:")
        print("   - memberBadgeId: \(badge.memberBadgeId)")
        print("   - acquiredAt: \(badge.acquiredAt)")
        print("   - badge.id: \(badgeInfo.badgeId)")
        print("   - badge.categoryName: \(badgeInfo.categoryName)")
        print("   - badge.name: \(badgeInfo.name)")
        print("   - badge.level: \(badgeInfo.level)")
        print("   - badge.targetValue: \(badgeInfo.targetValue)")
        print("   - badge.imageUrl: \(badgeInfo.imageUrl ?? "nil")")
        
        hasBadge = true
        goalTitle = badgeInfo.categoryName
        
        let current = badgeInfo.targetValue
        let total = badgeInfo.targetValue
        
        goalSubtitle = "\(badgeInfo.name) (\(current)/\(total))"
        goalProgress = total > 0 ? Double(current) / Double(total) : 0.0
        goalImageURL = badgeInfo.imageUrl
    }
    
    private func printCurrentState() {
        print("\n🎯 [MainViewModel] 최종 상태")
        print("   [Featured Book]")
        print("     - hasCurrentBook: \(hasCurrentBook)")
        print("     - title: \(featuredBook.title)")
        print("     - progress: \(featuredBook.progress)")
        print("     - page: \(featuredBook.currentPage)/\(featuredBook.totalPage)")
        print("     - rewardCount: \(featuredBook.rewardCount)")
        print("     - coverURL: \(featuredBook.coverURL ?? "nil")")
        print("   [Badge]")
        print("     - hasBadge: \(hasBadge)")
        print("     - goalTitle: \(goalTitle)")
        print("     - goalSubtitle: \(goalSubtitle)")
        print("     - goalProgress: \(goalProgress)")
        print("     - goalImageURL: \(goalImageURL ?? "nil")")
        print("======================\n")
    }
}
