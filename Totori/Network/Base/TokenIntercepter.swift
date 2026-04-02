//
//  TokenIntercepter.swift
//  Totori
//
//  Created by 정윤아 on 4/2/26.
//

import Foundation

import Alamofire

final class TokenInterceptor: RequestInterceptor {
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        // TODO: 리프레시 토큰으로 토큰 재발급 API 연동 필요
        print("🔄 토큰 만료! 리프레시 로직 대기 중...")
        completion(.doNotRetry)
    }
}
