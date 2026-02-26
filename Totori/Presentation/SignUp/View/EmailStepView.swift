//
//  EmailStepView.swift
//  Totori
//
//  Created by 정윤아 on 2/25/26.
//

import SwiftUI

struct EmailStepView: View {
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 0) {
                Text("이메일")
                    .font(.NotoSans_16_R)
                    .foregroundColor(.tBlack)
                
                Text("*")
                    .font(.NotoSans_16_R)
                    .foregroundColor(.main)
            }
            
            TextField("00000@토토리.com", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .font(.NotoSans_16_R)
                .foregroundColor(.tBlack)
                .textInputAutocapitalization(.never)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.tGray, lineWidth: 1))
        }
    }
}

#Preview {
    EmailStepView(viewModel: SignUpViewModel(role: .child))
}
