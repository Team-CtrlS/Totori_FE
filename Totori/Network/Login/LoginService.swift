//
//  LoginService.swift
//  Totori
//
//  Created by 정윤아 on 4/5/26.
//

import Combine
import Foundation

class LoginService {
    private let networkService = BaseService<TotoriAPI>()
    
    func login(param: LoginRequestDTO) -> AnyPublisher<LoginResponseDTO, NetworkError> {
        return networkService.request(.login(param: param), responseType: LoginResponseDTO.self)
    }
}
