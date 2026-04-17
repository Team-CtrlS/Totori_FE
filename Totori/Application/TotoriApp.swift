//
//  TotoriApp.swift
//  Totori
//
//  Created by 정윤아 on 2/8/26.
//

import Combine
import SwiftUI

@main
struct TotoriApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userRole") private var userRole: String = ""
    
    @State private var isCheckingAuth: Bool = true
    @State private var cancellables = Set<AnyCancellable>()
    
    @StateObject private var navState = NavigationState()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isCheckingAuth {
                    EmptyView()
                } else if isLoggedIn && hasAccessToken() {
                    if userRole == "CHILD" {
                        NavigationStack {
                            MainView()
                        }
                        .id(navState.rootId)
                        .environmentObject(navState)
                    } else if userRole == "PARENT" {
                        NavigationStack {
                            WeeklyReportView()
                        }
                        .id(navState.rootId)
                        .environmentObject(navState)
                    } else {
                        Text("권한 오류: \(userRole)")
                    }
                } else {
                    StartView()
                }
            }
            .onAppear {
                checkAutoLogin()
            }
        }
    }
    
    //MARK: - 자동 로그인
    
    private func checkAutoLogin() {
        let accessToken = KeychainManager.shared.load(key: .accessToken)
        let refreshToken = KeychainManager.shared.load(key: .refreshToken)
        
        if let access = accessToken, !access.isEmpty {
            print("accessToken 유효 - 자동 로그인")
            
            if userRole.isEmpty, let savedRole = UserDefaultManager.shared.getRole() {
                userRole = savedRole
            }
            
            isLoggedIn = true
            isCheckingAuth = false
            return
        }
        
        if let refresh = refreshToken, !refresh.isEmpty {
            print("토큰 재발급 시도")
            
            AuthService.shared.reissueToken()
                .receive(on: DispatchQueue.main)
                .sink{ completion in
                    if case .failure(let error) = completion {
                        print("❌ 자동 로그인 실패: \(error.localizedDescription)")
                        forceLogout()
                        isCheckingAuth = false
                    }
                } receiveValue: { response in
                    print("자동 로그인 성공")
                    userRole = response.role
                    isLoggedIn = true
                    isCheckingAuth = false
                }
                .store(in: &cancellables)
            return
        }
        
        print("저장된 토큰 없음")
        forceLogout()
        isCheckingAuth = false
    }
    
    private func hasAccessToken() -> Bool {
        let accessToken = KeychainManager.shared.load(key: .accessToken)
        return accessToken?.isEmpty == false
    }
    
    private func forceLogout() {
        isLoggedIn = false
        userRole = ""
        KeychainManager.shared.clearAll()
        UserDefaultManager.shared.clearAll()
    }
}
