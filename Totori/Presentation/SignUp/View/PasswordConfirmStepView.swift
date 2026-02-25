//
//  PasswordConfirmStepView.swift
//  Totori
//
//  Created by 정윤아 on 2/26/26.
//

import SwiftUI

struct PasswordConfirmStepView: View {
    @ObservedObject var viewModel = SignUpViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 0) {
                Text("비밀번호 확인")
                    .font(.NotoSans_16_R)
                    .foregroundColor(.tBlack)
                
                Text("*")
                    .font(.NotoSans_16_R)
                    .foregroundColor(.main)
            }
            
            HStack {
                SecureField("8자 이상", text: $viewModel.passwordConfirm)
                    .font(.NotoSans_16_R)
                    .foregroundColor(.tBlack)
                    .textInputAutocapitalization(.never)
                
                if viewModel.password == viewModel.passwordConfirm && !viewModel.passwordConfirm.isEmpty {
                    Image(.checkPink)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(
                (viewModel.password != viewModel.passwordConfirm && !viewModel.passwordConfirm.isEmpty) ? Color.red : Color.tGray, lineWidth: 1))
            
            if !viewModel.passwordConfirm.isEmpty && viewModel.password != viewModel.passwordConfirm {
                HStack {
                    Spacer()
                    
                    Text("비밀번호가 일치하지 않습니다.")
                        .font(.NotoSans_14_R)
                        .foregroundColor(.red)
                        .padding(.leading, 4)
                }
            }
        }
    }
}

#Preview {
    PasswordConfirmStepView()
}
