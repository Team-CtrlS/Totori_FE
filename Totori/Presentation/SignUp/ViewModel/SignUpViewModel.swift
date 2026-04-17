//
//  SignUpViewModel.swift
//  Totori
//
//  Created by 정윤아 on 2/25/26.
//
import Combine
import SwiftUI

class SignUpViewModel: ObservableObject {
    let role: SignUpType
    
    @Published var currentStep: Int = 1
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var name: String = ""
    
    @Published var navigateToFinalView: Bool = false
    @Published var navigateToConnectView: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let signUpService = SignUpService()
    
    init(role: SignUpType) {
        self.role = role
    }
    
    var hasCurrentInput: Bool {
        switch currentStep {
        case 1: return !email.isEmpty
        case 2: return !password.isEmpty
        case 3: return !passwordConfirm.isEmpty
        case 4: return !name.isEmpty
        default: return false
        }
    }
    
    var isPasswordConditionMet: Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[0-9]).{8,}$"
        return password.range(of: passwordRegex, options: .regularExpression) != nil
    }
    
    var isCurrentStepValid: Bool {
        switch currentStep {
        case 1:
            return !email.isEmpty && email.contains("@")
        case 2:
            return isPasswordConditionMet
        case 3:
            return password == passwordConfirm && isPasswordConditionMet
        case 4:
            return !name.isEmpty
        default:
            return false
        }
    }
    
    func goNextStep() {
        if currentStep < 4 {
            withAnimation{ currentStep += 1 }
        } else {
            print("최종 회원가입 로직 실행: \(email), \(password), \(name)")
            requestSignUp()
        }
    }
    
    func goPreviousStep() {
        if currentStep > 1 {
            withAnimation { currentStep -= 1 }
        }
    }
    
    private func requestSignUp() {
        let roleString = (role == .child) ? "CHILD" : "PARENT"
        
        let param = SignUpRequestDTO(
            loginId: self.email,
            password: self.password,
            name: self.name,
            role: roleString
        )
        
        signUpService.signUp(param: param)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("🚨 회원가입 실패 에러: \(error)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                print("✅ 회원가입 성공")
                
                if self.role == .child {
                    self.navigateToFinalView = true
                } else if self.role == .parent {
                    self.navigateToConnectView = true
                }
            }
            .store(in: &cancellables)
    }
}
