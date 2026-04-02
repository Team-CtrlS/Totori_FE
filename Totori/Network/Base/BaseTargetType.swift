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
        return ["Content-Type": "application/json"]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
}
