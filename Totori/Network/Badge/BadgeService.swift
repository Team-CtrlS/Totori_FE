//
//  BadgeService.swift
//  Totori
//
//  Created by 복지희 on 5/4/26.
//

import Combine
import Foundation

import CombineMoya
import Moya

class BadgeService {
    private let networkService = BaseService<TotoriAPI>()
    
    func getMyRepresentativeBadge() -> AnyPublisher<RepresentativeBadgeResponseDTO, NetworkError> {
        return networkService.request(.myRepresentativeBadge, responseType: RepresentativeBadgeResponseDTO.self)
    }
    
    func getMyAllBadges() -> AnyPublisher<AllBadgesResponseDTO, NetworkError> {
        return networkService.request(.myAllBadges, responseType: AllBadgesResponseDTO.self)
    }
}
