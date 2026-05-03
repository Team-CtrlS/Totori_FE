//
//  TokenIntercepter.swift
//  Totori
//
//  Created by 정윤아 on 4/2/26.
//

import Foundation

import Alamofire

final class TokenInterceptor: RequestInterceptor {
    
    // MARK: - Adapt
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        
        if let url = request.url?.absoluteString, url.contains("/api/auth/reissue") {
            completion(.success(request))
            return
        }
        
        if let accessToken = KeychainManager.shared.load(key: .accessToken), !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        if let url = request.request?.url?.absoluteString, url.contains("/api/auth/reissue") {
            Logger.error(.token, "reissue 자체가 401 - 강제 로그아웃")
            forceLogout()
            completion(.doNotRetryWithError(NetworkError.tokenExpired))
            return
        }
        
        Logger.info(.token, "토큰 만료 - 리프레시 시도")
        
        guard let refreshToken = KeychainManager.shared.load(key: .refreshToken),
              !refreshToken.isEmpty else {
            Logger.error(.token, "리프레시 토큰 없음")
            forceLogout()
            completion(.doNotRetryWithError(error))
            return
        }
        
        let reissueURL = "\(Config.baseURL)/api/auth/reissue"
        let headers: HTTPHeaders = [
            "RefreshToken": "Bearer \(refreshToken)",
            "Content-Type": "application/json"
        ]
        
        AF.request(reissueURL, method: .post, headers: headers)
            .responseData { [weak self] response in
                guard let self = self else { return }
                
                guard let statusCode = response.response?.statusCode else {
                    Logger.error(.token, "서버 응답 없음")
                    self.forceLogout()
                    completion(.doNotRetryWithError(NetworkError.unknown))
                    return
                }
                
                guard (200...299).contains(statusCode) else {
                    Logger.error(.token, "리프레시 토큰 만료 또는 무효 (상태 코드: \(statusCode))")
                    self.forceLogout()
                    completion(.doNotRetryWithError(NetworkError.tokenExpired))
                    return
                }
                
                switch response.result {
                case .success(let data):
                    do {
                        let newData = try self.decodeTokenResponse(data)
                        Logger.success(.token, "토큰 재발급 성공")
                        KeychainManager.shared.save(token: newData.accessToken, for: .accessToken)
                        KeychainManager.shared.save(token: newData.refreshToken, for: .refreshToken)
                        completion(.retry)  // adapt가 다시 호출되면서 새 토큰이 헤더에 박힘
                    } catch {
                        Logger.error(.decode, "토큰 응답 디코딩 실패: \(error)")
                        self.forceLogout()
                        completion(.doNotRetryWithError(error))
                    }
                case .failure(let refreshError):
                    Logger.error(.token, "리프레시 통신 실패: \(refreshError)")
                    self.forceLogout()
                    completion(.doNotRetryWithError(refreshError))
                }
            }
    }
    
    private func decodeTokenResponse(_ data: Data) throws -> LoginResponseDTO {
        let decoded = try JSONDecoder().decode(BaseResponse<LoginResponseDTO>.self, from: data)
        guard let result = decoded.data else {
            throw NetworkError.decodingError
        }
        return result
    }
    
    private func forceLogout() {
        DispatchQueue.main.async {
            KeychainManager.shared.clearAll()
            UserDefaultManager.shared.clearAll()
            
            NotificationCenter.default.post(name: .forceLogout, object: nil)
        }
    }
}

extension Notification.Name {
    static let forceLogout = Notification.Name("forceLogout")
}
