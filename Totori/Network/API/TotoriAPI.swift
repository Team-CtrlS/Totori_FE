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
}

extension TotoriAPI: BaseTargetType {
    var path: String {
        switch self {
        case .login:
            return "/api/auth/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .login:
            return .none
        default:
            return .bearer
        }
    }
}
