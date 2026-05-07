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
    @Published var summaryTotalCount: Int = 10
    @Published var summarysuccessCount: Int = 4
    @Published var summaryProgress: CGFloat = 0.7
    @Published var summaryBadgeUrl: Image = Image(.badgePurple)
    
    var progressText: String {
        "\(summarysuccessCount)/\(summaryTotalCount)"
    }
    
    @Published var items: [BadgeListItem] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let badgeService = BadgeService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchAll(category: BadgeCategory) {
        fetchCategoryBadges(category: category)
    }

    // 특정 카테고리의 뱃지 리스트를 가져오기
    func fetchCategoryBadges(category: BadgeCategory) {
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
                
                self.items = response.badges.map{
                    BadgeListItem(
                        id: $0.badgeId,
                        title: $0.name,
                        subtitle: category.getSubtitle(
                            current: $0.level,
                            target: $0.targetValue
                        ),
                        imageUrl: $0.imageUrl,
                        // TODO: progress response에 있으면 추가
                        progress: $0.isAcquired ? 1.0 : 0.7,
                        isUnlocked: $0.isAcquired
                    )
                }
            }
            .store(in: &cancellables)
    }
}
