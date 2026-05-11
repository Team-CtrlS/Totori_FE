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
    let category: String
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
    @Published var representativeCategory: BadgeCategory = .acorn

    @Published var badges: [BadgeItem] = []
    
    // status
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let memberService = MemberService()
    private let badgeService = BadgeService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchAll() {
        fetchAcornInfo()
        fetchRepresentativeBadge()
        fetchBadgeList()
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
                guard let self = self else { return }
                
                let badge = response.badgeResponseDto
                let category = BadgeCategory(rawValue: badge.category) ?? .acorn
                
                self.representativeCategory = category
                self.badgeSubTitle = category.getSubtitle(
                        current: badge.level,
                        target: badge.targetValue
                    )
                self.badgeTitle = badge.name
                self.imageUrl = badge.imageUrl
                self.progress = 0.8
            }
            .store(in: &cancellables)
    }
    
    // 전체 획득 뱃지 리스트 가져오기
    func fetchBadgeList() {
        badgeService.getMyAllBadges()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("전체 뱃지 조회 실패: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                // TODO: isUnlocked response에 추가되면 수정
                self.badges = response.map {
                    BadgeItem(
                        id: $0.badgeResponseDto.id,
                        isUnlocked: true,
                        imageUrl: $0.badgeResponseDto.imageUrl,
                        category: $0.badgeResponseDto.category
                    )
                }
            }
            .store(in: &cancellables)
    }
}
