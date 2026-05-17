//
//  WeeklyLearningResponseDTO.swift
//  Totori
//
//  Created by 복지희 on 5/14/26.
//

import Foundation

struct WeeklyLearningResponseDTO: Decodable {
    let weeklyData: [String: [WeeklyBookDTO]]
}

struct WeeklyBookDTO: Decodable {
    let bookId: Int
    let title: String
    let isCompleted: Bool
}
