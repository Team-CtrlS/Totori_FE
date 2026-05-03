//
//  Logger.swift
//  Totori
//
//  Created by 정윤아 on 4/12/26.
//


import Foundation
 
enum LogCategory: String {
    case network = "Network"
    case auth = "Auth"
    case token = "Token"
    case decode = "Decode"
    case ui = "UI"
}
 
enum LogLevel: String {
    case info = "ℹ️"
    case success = "✅"
    case warning = "⚠️"
    case error = "❌"
    case debug = "🔍"
}
 
struct Logger {
 
    #if DEBUG
    static var isEnabled = true
    #else
    static var isEnabled = false
    #endif
 
    // MARK: - Core
 
    static func log(
        _ level: LogLevel,
        category: LogCategory,
        _ message: String
    ) {
        guard isEnabled else { return }
        print("\(level.rawValue) [\(category.rawValue)] \(message)")
    }
 
    // MARK: - Convenience
 
    static func info(_ category: LogCategory, _ message: String) {
        log(.info, category: category, message)
    }
 
    static func success(_ category: LogCategory, _ message: String) {
        log(.success, category: category, message)
    }
 
    static func warning(_ category: LogCategory, _ message: String) {
        log(.warning, category: category, message)
    }
 
    static func error(_ category: LogCategory, _ message: String) {
        log(.error, category: category, message)
    }
 
    // MARK: - Network Specific
 
    static func request(method: String, url: String) {
        log(.info, category: .network, ">>> \(method) \(url)")
    }
 
    static func response(statusCode: Int, url: String) {
        let level: LogLevel = (200...299).contains(statusCode) ? .success : .error
        log(level, category: .network, "<<< [\(statusCode)] \(url)")
    }
 
    static func responseBody(_ data: Data) {
        guard isEnabled else { return }
        if let json = String(data: data, encoding: .utf8) {
            log(.debug, category: .network, "응답 바디: \(json)")
        }
    }
}
