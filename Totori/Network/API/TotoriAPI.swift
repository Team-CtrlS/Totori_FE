//
//  TotoriAPI.swift
//  Totori
//
//  Created by 정윤아 on 4/2/26.
//

import Foundation

import Alamofire
import Moya

enum TotoriAPI {
    //auth
    case login(param: LoginRequestDTO)
    case signUp(param: SignUpRequestDTO)
    case reissue
    
    //book
    case generateBook(param: BookGenerateRequestDTO)
}

extension TotoriAPI: BaseTargetType {
    var path: String {
        switch self {
        //auth
        case .login:
            return "/api/auth/login"
        case .signUp:
            return "/api/auth/signup"
        case .reissue:
            return "/api/auth/reissue"
            
        //book
        case .generateBook:
            return "/api/books/generate"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .signUp, .generateBook, .reissue:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(let param):
            return .requestJSONEncodable(param)
        case .signUp(let param):
            return .requestJSONEncodable(param)
        case .reissue:
            return .requestPlain
        case .generateBook(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .reissue:
            let refreshToken = KeychainManager.shared.load(key: .refreshToken) ?? ""
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(refreshToken)"
            ]
        default:
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
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .login, .signUp, .reissue:
            return .none
        default:
            return .bearer
        }
    }
}
