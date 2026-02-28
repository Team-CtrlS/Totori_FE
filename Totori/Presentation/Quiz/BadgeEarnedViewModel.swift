//
//  BadgeEarnedViewModel.swift
//  Totori
//
//  Created by user on 2/28/26.
//

import Combine
import Foundation

// MARK: - ViewModel

final class BadgeEarnedViewModel: ObservableObject {

    @Published var title: String = "도토리 수집가"
    @Published var description: String = "도토리 총 10개 모으기 (10/10)"
    @Published var imageUrl: String = ""
}
