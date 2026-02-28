//
//  MyPageMainViewModel.swift
//  Totori
//
//  Created by 복지희 on 2/28/26.
//

import SwiftUI

struct BadgeItem: Identifiable, Equatable {
    let id: Int
    let isUnlocked: Bool
    let imageUrl: String
    let progress: CGFloat
}

final class MyPageMainViewModel: ObservableObject {
    @Published var userName: String = "김밤톨"
    @Published var totalAcorn: Int = 18
    @Published var readBookCount: Int = 12
    
    @Published var badgeTitle: String = "도토리 수집가"
    @Published var badgeSubTitle: String = "도토리 총 10개 모으기 (4/10)"
    @Published var progress: CGFloat = 0.7

    @Published var badges: [BadgeItem] = [
        .init(id: 1, isUnlocked: true,  imageUrl: "badge_1", progress: 1),
        .init(id: 2, isUnlocked: false, imageUrl: "badge_2", progress: 0.3),
        .init(id: 3, isUnlocked: true,  imageUrl: "badge_3", progress: 1),
        .init(id: 4, isUnlocked: true,  imageUrl: "badge_4", progress: 1),
        .init(id: 5, isUnlocked: true,  imageUrl: "badge_5", progress: 0.8),
        .init(id: 6, isUnlocked: false, imageUrl: "badge_6", progress: 1)
    ]
}
