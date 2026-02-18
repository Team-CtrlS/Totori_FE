//
//  SignUpModal.swift
//  Totori
//
//  Created by 정윤아 on 2/16/26.
//

import SwiftUI

enum SignUpType {
    case child
    case parent
    
    var title: String {
        switch self {
        case .child:
            return "아동 회원가입"
        case .parent:
            return "보호자 회원가입"
        }
    }
    
    var titleColor: Color {
        switch self {
        case .child:
            return .point
        case .parent:
            return .main
        }
    }
    
    var text: String {
        switch self {
        case .child:
            return "최초 1회 선택 이후 변경이 불가능합니다.\n아동 계정으로 회원가입을 진행할까요?"
        case .parent:
            return "최초 1회 선택 이후 변경이 불가능합니다.\n보호자 계정으로 회원가입을 진행할까요?"
        }
    }
}

struct SignUpModal: View {
    
    // MARK - Properties
    
    let type: SignUpType
    let onCancel: () -> Void
    let onContinew: () -> Void
    
    // MARK - Body
    
    var body: some View {
        VStack(spacing: 10) {
            Image(.icLogoPurple)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .padding(.bottom, 10)
            
            HStack(spacing: 0){
                Text(type.title)
                    .foregroundColor(type.titleColor)
                Text("을 선택하셨습니다.")
                    .foregroundColor(.tBlack)
            }
            .font(.NotoSans_20_SB)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(type.text)
                .foregroundColor(.tBlack)
                .multilineTextAlignment(.leading)
                .font(.NotoSans_16_R)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 10){
                CTAButton(
                    title: "아니요",
                    type: .gray,
                    width: 151.5,
                    action: onCancel
                )
                
                CTAButton(
                    title: "계속하기",
                    type: .purple,
                    width: 151.5,
                    action: onContinew
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(.white)
        .cornerRadius(26)
        .frame(width: 353)
    }
}
