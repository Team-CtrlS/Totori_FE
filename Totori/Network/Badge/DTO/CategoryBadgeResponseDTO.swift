//
//  CategoryBadgeResponseDTO.swift
//  Totori
//
//  Created by 복지희 on 5/4/26.
//

import Foundation

struct CategoryBadgeResponseDTO: Decodable {
    let category: String
    let categoryName: String
    let currentCount: Int
    let badges: [BadgeDetailDTO]
}
