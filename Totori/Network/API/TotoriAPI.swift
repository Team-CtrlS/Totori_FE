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
    case attendance
    
    //book
    case generateBook(param: BookGenerateRequestDTO)
    case mainStatus
    case bookList(page: Int, size: Int)
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
        case .attendance:
            return "/api/child/attendance"
            
            //book
        case .generateBook:
            return "/api/books/generate"
        case .mainStatus:
            return "/api/books/main-status"
        case .bookList:
            return "/api/books"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .signUp, .generateBook, .reissue, .attendance:
            return .post
        case .mainStatus, .bookList:
            return .get
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
        case .mainStatus:
            return .requestPlain
        case .bookList(let page, let size):
            return .requestParameters(
                parameters: ["page": page, "size": size],
                encoding: URLEncoding.queryString
            )
        case .attendance:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .reissue:
            let refreshToken = KeychainManager.shared.load(key: .refreshToken) ?? ""
            return [
                "Content-Type": "application/json",
                "RefreshToken": "Bearer \(refreshToken)"
            ]
        default:
            return ["Content-Type": "application/json"]
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
