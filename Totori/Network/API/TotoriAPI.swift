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
}

extension TotoriAPI: BaseTargetType {
    var path: String {
        switch self {
        case .login:
            return "/api/auth/login"
        case .signUp:
            return "/api/auth/signup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .signUp:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(let param):
            return .requestJSONEncodable(param)
        case .signUp(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .login, .signUp:
            return .none
        default:
            return .bearer
        }
    }
}
