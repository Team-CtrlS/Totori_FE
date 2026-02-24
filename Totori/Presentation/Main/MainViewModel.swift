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
    let currentGame: Int
    let totalGame: Int
    let currentBookmark: Int
    let totalBookmark: Int
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
    
    // recentBook
    @Published var featuredBook = FeaturedBook(
            coverURL: nil,
            title: "도토리 숲의 비밀 모험",
            subtitle: "목표 달성까지 얼마 안 남았어!",
            rewardCount: 2,
            progress: 0.3,
            currentGame: 1,
            totalGame: 3,
            currentBookmark: 1,
            totalBookmark: 3
        )
    
    // bookList
    @Published var storyBooks: [BookType] = [
            .create(title: "이야기 시작하기"),
            .unread(title: "도토리 숲의 비밀 모험", cover: nil, purpleBackground: false),
            .unread(title: "도토리 숲의 비밀 모험", cover: nil, purpleBackground: false),
            .finished(title: "도토리 숲의 비밀 모험", cover: nil, purpleBackground: true)
        ]
}
