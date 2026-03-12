//
//  SettingView.swift
//  Totori
//
//  Created by 정윤아 on 3/12/26.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        CustomNavigationBar(centerType: .text("환경설정"), showsBackButton: true)
        
        Divider()
            .foregroundStyle(.tGray)
        
        RowView(title: "개인정보 관리", action: {print("클릭")})
        RowView(title: "알림 설정", action: {print("클릭")})
        RowView(title: "보호자 연결", action: {print("클릭")})
        RowView(title: "도움말(FAQ)", action: {print("클릭")})
        RowView(title: "로그아웃", titleColor: .red, icon: true, action: {print("클릭")})
        
        Spacer()
        
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
