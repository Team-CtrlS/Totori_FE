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
    @State private var showModal: Bool = false
    @State private var navigateToStart: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CustomNavigationBar(
                    centerType: .text("개인정보 관리"),
                    showsBackButton: true,
                    rightContent: {
                        NavigationLink {
                            InfoEditView()
                        } label: {
                            Image(.editPencil)
                                .renderingMode(.template)
                                .foregroundStyle(Color.main)
                        }})
                
                Circle()
                    .frame(width: 113, height: 113)
                    .foregroundStyle(.tGray)
                    .padding(.vertical, 30)
                
                infoRow(title: "이름", info: viewModel.name)
                infoRow(title: "이메일", info: viewModel.email)
                infoRow(title: "생년월일", info: "\(viewModel.birthDate)")
                infoRow(title: "총 생성한 도서", info: viewModel.totalBooks)
                infoRow(title: "보유 도토리", info: viewModel.acorns)
                
                HStack {
                    Button(action: { showModal = true }) {
                        Text("회원 탈퇴")
                            .font(.NotoSans_16_R)
                            .foregroundStyle(.red)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 21)
                .padding(.bottom, 30)
                
                Spacer()
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToStart) {
                StartView()
                    .navigationBarBackButtonHidden(true)
            }
            
            if showModal {
                QuestionModal(
                    type: .deleteAccount,
                    onCancel: { showModal = false },
                    onConfirm: {
                        showModal = false
                        //TODO: 회원 탈퇴 API 연결
                        navigateToStart = true
                    }
                )
                .zIndex(1)
            }
        }
    }
}

struct infoRow: View {
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
    InfoView()
}
