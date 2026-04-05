//
//  UserDefaultManager.swift
//  Totori
//
//  Created by 정윤아 on 4/5/26.
//

import Foundation

struct UserDefaultManager {
    static let shared = UserDefaultManager()
    private init() {}
    
    private let roleKey = "user_role"
    
    func saveRole(_ role: String) {
        UserDefaults.standard.set(role, forKey: roleKey)
    }
    
    func getRole() -> String? {
        return UserDefaults.standard.string(forKey: roleKey)
    }
    
    func clearAll() {
        UserDefaults.standard.removeObject(forKey: roleKey)
    }
}
