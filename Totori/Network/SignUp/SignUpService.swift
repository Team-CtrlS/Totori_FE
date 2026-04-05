//
//  SignUpService.swift
//  Totori
//
//  Created by 정윤아 on 4/5/26.
//

import Combine
import Foundation

import CombineMoya
import Moya

class SignUpService {
    private let networkService = BaseService<TotoriAPI>()
    
    func signUp(param: SignUpRequestDTO) -> AnyPublisher<EmptyData, NetworkError> {
        return networkService.request(.signUp(param: param), responseType: EmptyData.self)
    }
}
