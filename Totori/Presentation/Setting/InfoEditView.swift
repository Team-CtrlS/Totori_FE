//
//  InfoEditView.swift
//  Totori
//
//  Created by 정윤아 on 3/12/26.
//

import SwiftUI

struct InfoEditView: View {
    @StateObject private var viewModel = InfoViewModel()
    
    @State private var isEditing: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                centerType: .text("개인정보 편집"),
                showsBackButton: true,
                rightContent: {
                    Button(action: {
                        //TODO: - 수정완료 API 연결
                        dismiss()
                    }) {
                        Image(.check)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color.main)
                    }
                }
            )
            
            Circle()
                .frame(width: 113, height: 113)
                .foregroundStyle(.tGray)
                .padding(.vertical, 30)
            
            nameEditRow(title: "이름", text: $viewModel.name)
            nameEditRow(title: "이메일", text: $viewModel.email)
            birthEditRow(title: "생년월일", date: $viewModel.birthDate)
            infoRow(title: "총 생성한 도서", info: viewModel.totalBooks)
            infoRow(title: "보유 도토리", info: viewModel.acorns)
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct nameEditRow: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.NotoSans_16_R)
                .foregroundStyle(.tBlack)
            
            Spacer()
            
            TextField("", text: $text)
                .font(.NotoSans_16_R)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.tGray),
                    alignment: .bottom
                )
                .frame(maxWidth: 233)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 21)
    }
}

struct birthEditRow: View {
    let title: String
    @Binding var date: Date
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.NotoSans_16_R)
                .foregroundStyle(.tBlack)
            
            Spacer()
            
            DatePicker(
                "",
                selection: $date,
                displayedComponents: .date
            )
            .labelsHidden()
            .environment(\.locale, Locale(identifier: "ko_KR"))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 21)
    }
}

struct infoEditRow: View {
    let title: String
    let info: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.NotoSans_16_R)
                .foregroundStyle(.tBlack)
            
            Spacer()
            
            Text(info)
                .font(.NotoSans_16_R)
                .foregroundStyle(.textGray)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 21)
        
    }
}

#Preview {
    InfoEditView()
}
