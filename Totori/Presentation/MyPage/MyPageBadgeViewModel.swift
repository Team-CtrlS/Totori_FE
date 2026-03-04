//
//  MyPageBadgeViewModel.swift
//  Totori
//
//  Created by 복지희 on 3/1/26.
//

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

    // 달성 가까운 뱃지
    @Published var closestBadgeTitle: String = "도토리 수집가"
    @Published var closestBadgeSubtitle: String = "도토리 총 10개 모으기 (4/10)"
    @Published var closestBadgeProgress: CGFloat = 0.4
    @Published var closestBadgeUrl: String = ""

    @Published var items: [BadgeListItem] = [
        .init(id: 1, title: "첫 도토리 수확", subtitle: "도토리 총 10개 모으기 (4/10)", imageUrl: "", progress: 0.4, isUnlocked: false),
        .init(id: 2, title: "도토리 초보수집가", subtitle: "도토리 총 10개 모으기 (4/10)", imageUrl: "", progress: 1, isUnlocked: true),
        .init(id: 3, title: "도토리 수집가", subtitle: "도토리 총 10개 모으기 (4/10)", imageUrl: "", progress: 1, isUnlocked: true),
        .init(id: 4, title: "도토리 베테랑", subtitle: "도토리 총 10개 모으기 (4/10)", imageUrl: "", progress: 0.8, isUnlocked: false),
        .init(id: 5, title: "도토리 히어로", subtitle: "도토리 총 10개 모으기 (4/10)", imageUrl: "", progress: 1, isUnlocked: true)
    ]
}
