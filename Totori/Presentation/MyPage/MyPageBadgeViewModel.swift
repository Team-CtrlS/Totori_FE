//
//  MyPageBadgeViewModel.swift
//  Totori
//
//  Created by 복지희 on 3/1/26.
//

import Combine
import SwiftUI

// MARK: - Models

struct BadgeListItem: Identifiable, Equatable {
    let id: Int
    let title: String
    let subtitle: String
    let imageUrl: String
    let progress: CGFloat
    let isUnlocked: Bool
}

// MARK: - ViewModel

final class MyPageBadgeViewModel: ObservableObject {

    // 상단
    @Published var summayTitle: String = "도토리 수집가"
    @Published var summaryTotalCount: Int = 11
    @Published var summarysuccessCount: Int = 4
    @Published var summaryProgress: CGFloat = 0.7
    @Published var summaryBadgeUrl: String = ""
    
    var progressText: String {
        "\(summarysuccessCount)/\(summaryTotalCount)"
    }
    
    @Published var items: [BadgeListItem] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let badgeService = BadgeService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchAll(category: BadgeCategory, initialBadgeId: Int) {
        fetchCategoryBadges(category: category, initialBadgeId: initialBadgeId)
    }

    // 특정 카테고리의 뱃지 리스트를 가져오기
    func fetchCategoryBadges(category: BadgeCategory,initialBadgeId: Int) {
        isLoading = true
            
        badgeService.getCategoryBadges(category: category.rawValue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("카테고리 뱃지 조회 실패: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                let category = BadgeCategory(rawValue: response.category) ?? .acorn
                let currentCount = response.currentCount
                
                self.items = response.badges.map{
                    BadgeListItem(
                        id: $0.badgeId,
                        title: $0.name,
                        subtitle: category.getSubtitle(
                            current: currentCount,
                            target: $0.targetValue
                        ),
                        imageUrl: $0.imageUrl,
                        // TODO: progress response에 있으면 추가
                        progress: $0.isAcquired ? 1.0 : (CGFloat(currentCount) / CGFloat($0.targetValue)),
                        isUnlocked: $0.isAcquired
                    )
                }
                
                // 대표뱃지 설정
                // TODO: totalCount, successCount 추가
                if let selectedItem = items.first(where: { $0.id == initialBadgeId }) {
                    self.summayTitle = selectedItem.title
                    self.summaryProgress = selectedItem.progress
                    self.summaryBadgeUrl = selectedItem.imageUrl
                }
            }
            .store(in: &cancellables)
    }
}
