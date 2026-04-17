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

final class BaseService<Target: BaseTargetType> {
    
    // MARK: - Properties
    
    private let provider: MoyaProvider<Target>
    
    // MARK: - Init
    
    init() {
        let session = Session(interceptor: TokenInterceptor())
        
        let authPlugin = AccessTokenPlugin { _ in
            KeychainManager.shared.load(key: .accessToken) ?? ""
        }
        
        let loggerPlugin = NetworkLogger()
        
        self.provider = MoyaProvider<Target>(
            session: session,
            plugins: [authPlugin, loggerPlugin]
        )
    }
    
    // MARK: - Request
    
    func request<T: Decodable>(
        _ target: Target,
        responseType: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        
        provider.requestPublisher(target)
            .tryMap { [weak self] response -> T in
                guard let self = self else { throw NetworkError.unknown }
                
                let data = response.data
                
                self.logResponse(data)
                
                guard !data.isEmpty else {
                    return try self.handleEmptyData()
                }
                
                return try self.decodeResponse(data: data)
            }
            .mapError { [weak self] error in
                return self?.mapToNetworkError(error) ?? .unknown
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Private Methods

private extension BaseService {
    
    func logResponse(_ data: Data) {
        if let jsonString = String(data: data, encoding: .utf8) {
            print("📢 서버 원본 응답: \(jsonString)")
        }
    }
    
    func decodeResponse<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        
        do {
            let decoded = try decoder.decode(BaseResponse<T>.self, from: data)
            
            if let result = decoded.data {
                return result
            }
            
            if T.self == EmptyData.self {
                return EmptyData() as! T
            }
            
            throw NetworkError.decodingError
            
        } catch {
            print("❌ 디코딩 실패: \(error)")
            throw NetworkError.decodingError
        }
    }
    
    func handleEmptyData<T>() throws -> T {
        if T.self == EmptyData.self {
            return EmptyData() as! T
        }
        throw NetworkError.decodingError
    }
    
    func mapToNetworkError(_ error: Error) -> NetworkError {
        
        if let networkError = error as? NetworkError {
            return networkError
        }
        
        if let moyaError = error as? MoyaError,
           case let .statusCode(response) = moyaError {
            
            let statusCode = response.statusCode
            
            if statusCode == 401 {
                return .tokenExpired
            }
            
            if (500...599).contains(statusCode) {
                return .internalServerError
            }
            
            if let errorBody = try? JSONDecoder().decode(ErrorResponse.self, from: response.data) {
                return .serverError(status: statusCode, message: errorBody.message)
            }
            
            return .clientError(statusCode: statusCode)
        }
        
        if error is DecodingError {
            return .decodingError
        }
        
        return .unknown
    }
}
