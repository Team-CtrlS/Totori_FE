//
//  NameStepView.swift
//  Totori
//
//  Created by 정윤아 on 2/25/26.
//

import SwiftUI

struct NameStepView: View {
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 0) {
                Text("이름")
                    .font(.NotoSans_16_R)
                    .foregroundColor(.tBlack)
                
                Text("*")
                    .font(.NotoSans_16_R)
                    .foregroundColor(.main)
            }
            
            TextField("김토리", text: $viewModel.name)
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
    NameStepView(viewModel: SignUpViewModel(role: .child))
}
