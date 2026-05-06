//
//  BadgeCategory.swift
//  Totori
//
//  Created by user on 5/7/26.
//

import Foundation

enum BadgeCategory: String {
    case bookCreated = "BOOK_CREATED"
    case bookRead = "BOOK_READ"
    case attendance = "ATTENDANCE"
    case acorn = "ACORN"

    func getSubtitle(current: Int, target: Int) -> String {
        switch self {
        case .bookCreated:
            return "책 \(target)권 생성하기 (\(current)/\(target))"
        case .bookRead:
            return "동화 \(target)권 읽기 도전 중! (\(current)/\(target))"
        case .attendance:
            return "연속 출석 \(target)일 달성하기 (\(current)/\(target)일)"
        case .acorn:
            return "도토리 총 \(target)개 모으기 (\(current)/\(target))"
        }
    }
}
