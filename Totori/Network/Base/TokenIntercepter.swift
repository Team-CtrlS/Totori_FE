//
//  TokenIntercepter.swift
//  Totori
//
//  Created by 정윤아 on 4/2/26.
//

import Foundation

import Alamofire

final class TokenInterceptor: RequestInterceptor {
    
    private func decodeTokenResponse(_ data: Data) throws -> LoginResponseDTO {
          let decoded = try JSONDecoder().decode(BaseResponse<LoginResponseDTO>.self, from: data)
          
          guard let result = decoded.data else {
              throw NetworkError.decodingError
          }
          
          return result
      }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        print("🔄 토큰 만료! 리프레시 로직 대기 중...")
        
        guard let refreshToken = KeychainManager.shared.load(key: .refreshToken) else {
            print("❌ 리프레시 토큰이 없습니다. 다시 로그인해야 합니다.")
            forceLogout()
            completion(.doNotRetryWithError(error))
            return
        }
        
        let reissueURL = "\(Config.baseURL)/api/auth/reissue"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(refreshToken)"
        ]
        
        AF.request(reissueURL, method: .post, headers: headers)
            .responseData { [weak self] response in
                
                guard let self = self else { return }
                
                switch response.result {
                    
                case .success(let data):
                    do {
                        let newData = try self.decodeTokenResponse(data)
                        
                        print("✅ 토큰 재발급 성공")
                        
                        KeychainManager.shared.save(token: newData.accessToken, for: .accessToken)
                        KeychainManager.shared.save(token: newData.refreshToken, for: .refreshToken)
                        
                        completion(.retry)
                        
                    } catch {
                        print("❌ 디코딩 실패: \(error)")
                        self.forceLogout()
                        completion(.doNotRetryWithError(error))
                    }
                    
                case .failure(let refreshError):
                    print("❌ 리프레시 실패: \(refreshError)")
                    self.forceLogout()
                    completion(.doNotRetryWithError(refreshError))
                }
            }
    }
    
    private func forceLogout() {
        KeychainManager.shared.clearAll()
        UserDefaultManager.shared.clearAll()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
}
