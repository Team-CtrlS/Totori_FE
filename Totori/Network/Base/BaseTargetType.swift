//
//  BaseTargetType.swift
//  Totori
//
//  Created by 정윤아 on 4/2/26.
//

import Foundation

import Moya

protocol BaseTargetType: TargetType, AccessTokenAuthorizable {}

extension BaseTargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var headers: [String: String]? {
        var defaultHeaders = ["Content-Type": "application/json"]
        
        if self.authorizationType != .none {
            if let token = KeychainManager.shared.load(key: .accessToken), !token.isEmpty {
                defaultHeaders["Authorization"] = "Bearer \(token)"
            } else {
                print("🚨 토큰이 필요한 API인데 키체인에 토큰이 비어있습니다!")
            }
        }
        
        return defaultHeaders
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
}
