//
//  NetworkError.swift
//  Totori
//
//  Created by 정윤아 on 4/2/26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case internalServerError
    case serverError(status: Int, message: String)
    case clientError(statusCode: Int)
    case tokenExpired
    case decodingError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .serverError(let status, let message): return "[\(status)] \(message)"
        case .clientError(let statusCode): return "[\(statusCode)] 요청에 실패했어요. 다시 시도해주세요"
        case .tokenExpired: return "세션이 만료되었습니다. 다시 로그인해주세요."
        case .decodingError: return "데이터를 읽어오는데 실패했습니다."
        case .unknown: return "알 수 없는 에러가 발생했습니다."
        default: return "네트워크 상태를 확인해주세요."
        }
    }
}
