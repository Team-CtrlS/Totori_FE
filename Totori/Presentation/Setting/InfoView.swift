//
//  InfoView.swift
//  Totori
//
//  Created by 정윤아 on 3/12/26.
//

import SwiftUI

struct InfoView: View {
    @StateObject private var viewModel = InfoViewModel()
    
    @State private var isEditing: Bool = false
    
    var body: some View {
        CustomNavigationBar(centerType: .text("개인정보 관리"), showsBackButton: true)
        
        Circle()
            .frame(width: 113, height: 113)
            .foregroundStyle(.tGray)
        
        Text(viewModel.name)
            .font(.NotoSans_24_SB)
            .foregroundStyle(.tBlack)
        
        infoRow(title: "생년월일", info: $viewModel.birthDate, isEditing: isEditing)
        infoRow(title: "성별", info: $viewModel.gender, isEditing: isEditing)
        infoRow(title: "휴대폰번호", info: $viewModel.phoneNumber, isEditing: isEditing)
        
        infoRow(title: "총 생성한 도서", info: .constant(viewModel.totalBooks), isEditing: isEditing, isEditableField: false)
        infoRow(title: "보유 도토리", info: .constant(viewModel.acorns), isEditing: isEditing, isEditableField: false)
        
        HStack {
            Button(action: {print("로그아웃")}) {
                Text("회원 탈퇴")
                    .font(.NotoSans_16_R)
                    .foregroundStyle(.red)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 21)
        .padding(.bottom, 30)
        
        CTAButton(title: isEditing ? "수정 완료" : "수정하기", type: .purple, action: {
            if isEditing {
                viewModel.saveChanges()
            }
            isEditing.toggle()
        })
        
        Spacer()
    }
}

struct infoRow: View {
    let title: String
    @Binding var info: String
    var isEditing: Bool
    
    var isEditableField: Bool = true
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.NotoSans_16_R)
                .foregroundStyle(.tBlack)
            
            Spacer()
            
            if isEditing && isEditableField {
                TextField("입력해주세요", text: $info)
                    .font(.NotoSans_16_R)
                    .foregroundStyle(.tBlack)
                    .multilineTextAlignment(.trailing)
            } else {
                Text(info)
                    .font(.NotoSans_16_R)
                    .foregroundStyle(.textGray)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 21)
        
    }
}

#Preview {
    InfoView()
}
