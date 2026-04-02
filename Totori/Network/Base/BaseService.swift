//
//  BaseService.swift
//  Totori
//
//  Created by 정윤아 on 4/2/26.
//

import Combine
import Foundation

import Alamofire
import CombineMoya
import Moya

class BaseService<Target: BaseTargetType> {
    private let provider: MoyaProvider<Target>
    
    init() {
        let session = Session(interceptor: TokenInterceptor())
        
        let authPlugin = AccessTokenPlugin { _ in
            return KeychainManager.shared.load(key: .accessToken) ?? ""
        }
        
        let loggerPlugin = NetworkLogger()
        
        self.provider = MoyaProvider<Target>(
            session: session,
            plugins: [authPlugin, loggerPlugin]
        )
    }
    
    func request<T: Decodable>(_ target: Target, responseType: T.Type) -> AnyPublisher<T, NetworkError> {
        return provider.requestPublisher(target)
            .tryMap { response -> T in
                
                let data = response.data
                
                if data.isEmpty || responseType == EmptyData.self {
                    if let empty = EmptyData() as? T { return empty }
                    throw NetworkError.decodingError
                }
                
                let decoded = try JSONDecoder().decode(BaseResponse<T>.self, from: data)
                guard let result = decoded.data else {
                    throw NetworkError.decodingError
                }
                return result
            }
            .mapError { error -> NetworkError in
                if let networkError = error as? NetworkError { return networkError }
                
                if let moyaError = error as? MoyaError, case let .statusCode(response) = moyaError {
                    let statusCode = response.statusCode
                    
                    if statusCode == 401 { return .tokenExpired }
                    if (500...599).contains(statusCode) { return .internalServerError }
                    
                    if let errorBody = try? JSONDecoder().decode(ErrorResponse.self, from: response.data) {
                        return .serverError(status: statusCode, message: errorBody.message)
                    } else {
                        return .clientError(statusCode: statusCode)
                    }
                }
                
                if error is DecodingError { return .decodingError }
                
                return .unknown
            }
            .eraseToAnyPublisher()
    }
}
