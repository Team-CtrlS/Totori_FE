//
//  BadgeDTO.swift
//  Totori
//
//  Created by 복지희 on 5/4/26.
//

import Foundation

struct BadgeInfoDTO: Decodable {
    let id: Int
    let category: String
    let categoryName: String
    let name: String
    let level: Int
    let targetValue: Int
    let imageUrl: String
}

struct BadgeDetailDTO: Decodable {
    let badgeId: Int
    let name: String
    let level: Int
    let targetValue: Int
    let imageUrl: String
    let isAcquired: Bool
}
