//
//  PasswordStepView.swift
//  Totori
//
//  Created by 정윤아 on 2/26/26.
//

import SwiftUI

struct PasswordStepView: View {
    @ObservedObject var viewModel = SignUpViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 0) {
                Text("비밀번호")
                    .font(.NotoSans_16_R)
                    .foregroundColor(.tBlack)
                
                Text("*")
                    .font(.NotoSans_16_R)
                    .foregroundColor(.main)
            }
            
            HStack {
                SecureField("8자 이상", text: $viewModel.password)
                    .font(.NotoSans_16_R)
                    .foregroundColor(.tBlack)
                    .textInputAutocapitalization(.never)
                
                if viewModel.isPasswordConditionMet {
                    Image(.checkPink)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(
                (!viewModel.isPasswordConditionMet && !viewModel.password.isEmpty) ? Color.red :Color.tGray, lineWidth: 1))
            
            if !viewModel.password.isEmpty && !viewModel.isPasswordConditionMet {
                HStack {
                    Spacer()
                    
                    Text("소문자 영어와 숫자를 조합하여 8자 이상 입력해주세요.")
                        .font(.NotoSans_14_R)
                        .foregroundColor(.red)
                        .padding(.leading, 4)
                }
            }
        }
    }
}

#Preview {
    PasswordStepView()
}
