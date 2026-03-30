//
//  SettingView.swift
//  Totori
//
//  Created by 정윤아 on 3/12/26.
//

import SwiftUI

struct SettingView: View {
    @State private var showModal: Bool = false
    @State private var navigateToStart: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CustomNavigationBar(centerType: .text("환경설정"), showsBackButton: true)
                
                Divider()
                    .foregroundStyle(.tGray)
                
                RowView(title: "개인정보 관리", action: {print("클릭")})  // TODO: - 페이지 연결
                RowView(title: "알림 설정", action: {print("클릭")})
                RowView(title: "보호자 연결", action: {print("클릭")})
                RowView(title: "도움말(FAQ)", action: {print("클릭")})
                RowView(title: "로그아웃",
                        titleColor: .red,
                        icon: true,
                        action: { showModal = true}
                )
                
                Spacer()
            }
            .navigationDestination(isPresented: $navigateToStart) {
                StartView()
                    .navigationBarBackButtonHidden(true)
            }
            
            if showModal {
                QuestionModal(
                    type: .logout,
                    onCancel: { showModal = false },
                    onConfirm: {
                        showModal = false
                        //TODO: 로그 아웃 API 연결
                        navigateToStart = true
                    }
                )
                .zIndex(1)
            }
        }
    }
}

struct RowView: View {
    let title: String
    var titleColor: Color = .tBlack
    var icon: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                if icon {
                    Image(.logout)
                        .padding(.trailing,4)
                }
                
                Text(title)
                    .font(.NotoSans_16_R)
                    .foregroundStyle(titleColor)
                
                Spacer()
                
                Image(.rightGray)
                    .frame(width: 24, height: 24)
            }
            .padding(.vertical, 21)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    SettingView()
}
