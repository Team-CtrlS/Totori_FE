//
//  LoginViewModel.swift
//  Totori
//
//  Created by 정윤아 on 4/5/26.
//

import Combine
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var loginId: String = ""
    @Published var password: String = ""
    
    @Published var isLoginSuccessful: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let loginService = LoginService()
    private var cancellables = Set<AnyCancellable>()
    
    let expectedRole: SignUpType
    
    init(expectedRole: SignUpType) {
        self.expectedRole = expectedRole
    }
    
    func login() {
        guard !loginId.isEmpty, !password.isEmpty else {
            self.errorMessage = "아이디와 비밀번호를 모두 입력해주세요."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let param = LoginRequestDTO(loginId: loginId, password: password)
        
        loginService.login(param: param)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.errorDescription
                }
            } receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                
                let isValidRole = (self.expectedRole == .child && responseData.role == "CHILD") ||
                (self.expectedRole == .parent && responseData.role == "PARENT")
                
                if isValidRole {
                    print("✅ 로그인 성공! 받아온 권한: \(responseData.role)")
                    
                    KeychainManager.shared.save(token: responseData.token, for: .accessToken)
                    UserDefaults.standard.set(responseData.role, forKey: "userRole")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                } else {
                    self.errorMessage = "해당 계정은 \(self.expectedRole == .child ? "아이" : "보호자") 권한이 아닙니다."
                }
            }
            .store(in: &cancellables)
    }
}
