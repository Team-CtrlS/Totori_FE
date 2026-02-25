//
//  SignUpViewModel.swift
//  Totori
//
//  Created by 정윤아 on 2/25/26.
//
import Combine
import SwiftUI

class SignUpViewModel: ObservableObject {
    
    @Published var currentStep: Int = 1
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var name: String = ""
    
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
            //TODO: - main
            print("최종 회원가입 로직 실행: \(email), \(password), \(name)")
        }
    }
    
    func goPreviousStep() {
        if currentStep > 1 {
            withAnimation { currentStep -= 1 }
        }
    }
}
