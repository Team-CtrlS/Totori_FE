//
//  MyPageMainViewModel.swift
//  Totori
//
//  Created by 복지희 on 2/28/26.
//

import Combine
import SwiftUI

// MARK: - Model

struct BadgeItem: Identifiable, Equatable {
    let id: Int
    let isUnlocked: Bool
    let imageUrl: String
    let progress: CGFloat
}

// MARK: - ViewModel

final class MyPageMainViewModel: ObservableObject {
    @Published var userName: String = "김밤톨"
    @Published var totalAcorn: Int = 18
    @Published var readBookCount: Int = 12
    
    @Published var badgeTitle: String = "도토리 수집가"
    @Published var badgeSubTitle: String = "도토리 총 10개 모으기 (4/10)"
    @Published var imageUrl: String? = nil
    @Published var progress: CGFloat = 0.7

    @Published var badges: [BadgeItem] = [
        .init(id: 1, isUnlocked: true,  imageUrl: "badge_1", progress: 1),
        .init(id: 2, isUnlocked: false, imageUrl: "badge_2", progress: 0.3),
        .init(id: 3, isUnlocked: true,  imageUrl: "badge_3", progress: 1),
        .init(id: 4, isUnlocked: true,  imageUrl: "badge_4", progress: 1),
        .init(id: 5, isUnlocked: true,  imageUrl: "badge_5", progress: 0.8),
        .init(id: 6, isUnlocked: false, imageUrl: "badge_6", progress: 1)
    ]
    
    // status
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let memberService = MemberService()
    private let badgeService = BadgeService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchAll() {
        fetchAcornInfo()
        fetchRepresentativeBadge()
    }
    
    // 도토리 및 유저 정보 가져오기
    func fetchAcornInfo() {
        isLoading = true
            
        memberService.getAcorn()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("마이페이지 정보 조회 실패: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                self.userName = response.name
                self.totalAcorn = response.acorn
            }
            .store(in: &cancellables)
    }
    
    // 대표 뱃지 정보 가져오기
    func fetchRepresentativeBadge() {
        badgeService.getMyRepresentativeBadge()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("대표 뱃지 조회 실패: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                self?.applyRepresentativeBadge(response)
            }
            .store(in: &cancellables)
    }
    
    private func applyRepresentativeBadge(_ dto: MemberBadgeResponseDTO) {
        let badge = dto.badgeResponseDto
        let category = BadgeCategory(rawValue: badge.category ?? "") ?? .acorn
        self.badgeSubTitle = category.getSubtitle(
                current: badge.level,
                target: badge.targetValue
            )
        self.badgeTitle = badge.name
        self.imageUrl = badge.imageUrl
        self.progress = 0.8
    }
}
