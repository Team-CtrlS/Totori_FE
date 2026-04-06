//
//  Config.swift
//  Totori
//
//  Created by 정윤아 on 4/2/26.
//

import Foundation

struct Config {
    static let baseURL: String = {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("🚨 Info.plist에 BASE_URL 설정이 누락되었습니다!")
        }
        print("🔍 현재 Info.plist에서 읽어온 BASE_URL 값: [\(urlString)]")
        return urlString
    }()
}
