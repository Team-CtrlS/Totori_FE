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
    case makeBook(audioURL: URL)
    case bookDetail(bookId: Int)
    case uploadReadingAudio(bookId: Int, sentenceNum: Int, audioURL: URL)
    
    //member
    case acorn
    
    //badge
    case myRepresentativeBadge
    case myAllBadges
    case categoryBadges(category: String)
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
        case .makeBook: return "/api/books/make"
        case .bookDetail(let bookId):
            return "/api/books/\(bookId)"
        case .uploadReadingAudio(let bookId, let sentenceNum, _):
            return "/api/books/\(bookId)/reading/\(sentenceNum)"
            
            //member
        case .acorn:
            return "/api/members/me/acorns"
            
            //badge
        case .myRepresentativeBadge:
            return "/api/badges/my/representative"
        case .myAllBadges:
            return "/api/badges/my"
        case .categoryBadges(let category):
            return "/api/badges/my/categories/\(category)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .signUp, .generateBook, .reissue, .attendance, .makeBook, .uploadReadingAudio:
            return .post
        case .mainStatus, .bookList, .acorn, .myRepresentativeBadge, .myAllBadges, .categoryBadges, .bookDetail:
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
        case .bookDetail:
            return .requestPlain
        case .attendance:
            return .requestPlain
        case .makeBook(let audioURL):
            guard let audioData = try? Data(contentsOf: audioURL) else {
                return .requestPlain
            }
            
            let formData = MultipartFormData(
                provider: .data(audioData),
                name: "audio",
                fileName: audioURL.lastPathComponent,
                mimeType: "audio/m4a"
            )
            return .uploadMultipart([formData])
        case .uploadReadingAudio(_, _, let audioURL):
            guard let audioData = try? Data(contentsOf: audioURL) else {
                return .requestPlain
            }
            let formData = MultipartFormData(
                provider: .data(audioData),
                name: "audio",
                fileName: audioURL.lastPathComponent,
                mimeType: "audio/m4a"
            )
            return .uploadMultipart([formData])
        case .acorn:
            return .requestPlain
        case .myRepresentativeBadge:
            return .requestPlain
        case .myAllBadges:
            return .requestPlain
        case .categoryBadges(_):
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
