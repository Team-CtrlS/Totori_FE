//
//  MemberService.swift
//  Totori
//
//  Created by 복지희 on 5/3/26.
//

import Combine
import Foundation

import CombineMoya
import Moya

class MemberService {
    private let networkService = BaseService<TotoriAPI>()
    
    func getAcorn() -> AnyPublisher<AcornResponseDTO, NetworkError> {
        return networkService.request(.acorn, responseType: AcornResponseDTO.self)
    }
}
