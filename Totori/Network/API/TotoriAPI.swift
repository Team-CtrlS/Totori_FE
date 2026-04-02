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
    case totoriLogin
}

extension TotoriAPI: BaseTargetType {
    var path: String {
        switch self {
        case .totoriLogin:
            return "/api/auth/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .totoriLogin:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .totoriLogin:
            return .requestPlain
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .totoriLogin:
            return .none
        default:
            return .bearer
        }
    }
}
