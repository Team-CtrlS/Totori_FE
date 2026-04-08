//
//  BaseResponse.swift
//  Totori
//
//  Created by 정윤아 on 4/2/26.
//

import Foundation

// 성공 응답
struct BaseResponse<T: Decodable>: Decodable {
    let status: Int
    let code: String
    let message: String
    let data: T?
}

extension BaseResponse: Sendable where T: Sendable {}

// 반환 값이 없을 때
struct EmptyData: Decodable, Sendable {}

// 에러 응답
struct ErrorResponse: Decodable, Sendable {
    let timestamp: String
    let status: Int
    let errorCode: String
    let message: String
    let path: String
}
