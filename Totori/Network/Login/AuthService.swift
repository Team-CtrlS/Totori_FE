//
//  AuthService.swift
//  Totori
//
//  Created by 정윤아 on 4/12/26.
//

import Combine
import Foundation

final class AuthService {
    static let shared = AuthService()
    private let networkService = BaseService<TotoriAPI>()
    private init() {}
    
    func reissueToken() -> AnyPublisher<LoginResponseDTO, NetworkError> {
        return networkService.request(.reissue, responseType: LoginResponseDTO.self)
            .handleEvents(receiveOutput: { response in
                KeychainManager.shared.save(token: response.accessToken, for: .accessToken)
                KeychainManager.shared.save(token: response.refreshToken, for: .refreshToken)
                
                UserDefaultManager.shared.saveRole(response.role)
                Logger.success(.token, "토큰 재발급 및 저장 완료 - role: \(response.role)")
            })
            .eraseToAnyPublisher()
    }
}
