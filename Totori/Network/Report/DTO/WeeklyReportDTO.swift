//
//  WeeklyReportDTO.swift
//  Totori
//
//  Created by 복지희 on 5/8/26.
//

import Foundation

struct WeeklyReportDTO: Decodable {
    let child: ChildDTO
    let weekStart: String
    let weekEnd: String
    let weeklyLearning: [WeeklyLearningItemDTO]
    let completion: WeeklyCompletionDTO
    let wcpm: WeeklyWCPMDTO
}

struct WeeklyLearningItemDTO: Decodable {
    let date: String
    let dayOfWeek: String
    let studied: Bool
    let bookCount: Int
}

struct WeeklyCompletionDTO: Decodable {
    let completedBookCount: Int
    let totalBookCount: Int
}

struct WeeklyWCPMDTO: Decodable {
    let average: Double
    let daily: [DataPointDTO]
}
