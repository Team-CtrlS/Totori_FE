//
//  KeychainManager.swift
//  Totori
//
//  Created by 정윤아 on 4/2/26.
//

import Foundation

import SwiftKeychainWrapper

struct KeychainManager {
    static let shared = KeychainManager()
    private init() {}
    
    enum Key: String {
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
    }
    
    func save(token: String, for key: Key) {
        KeychainWrapper.standard.set(token, forKey: key.rawValue)
    }
    
    func load(key: Key) -> String? {
        return KeychainWrapper.standard.string(forKey: key.rawValue)
    }
    
    func delete(key: Key) {
        KeychainWrapper.standard.removeObject(forKey: key.rawValue)
    }
    
    func clearAll() {
        KeychainWrapper.standard.removeAllKeys()
    }
    
}
