//
//  MemberBadgeResponseDTO.swift
//  Totori
//
//  Created by 복지희 on 5/4/26.
//

import Foundation

struct MemberBadgeResponseDTO: Decodable {
    let memberBadgeId: Int
    let badgeResponseDto: BadgeInfoDTO
    let acquiredAt: String
}

// 전체 획득 뱃지 리스트 응답
typealias AllBadgesResponseDTO = [MemberBadgeResponseDTO]

// 대표 뱃지 응답
typealias RepresentativeBadgeResponseDTO = MemberBadgeResponseDTO
