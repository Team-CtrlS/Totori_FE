//
//  QuestionModal.swift
//  Totori
//
//  Created by 정윤아 on 3/27/26.
//

import SwiftUI

enum QuestionType {
    case logout
    case exitReading
    case deleteAccount
    
    var title: String {
        switch self {
        case .logout: return "로그아웃하실 건가요?"
        case .exitReading: return "동화를 여기까지만 읽을까요?"
        case .deleteAccount: return "정말 탈퇴하시겠어요?"
        }
    }
    
    var titleColor: Color {
        switch self {
        case .deleteAccount: return .tRed
        default : return .tBlack
        }
    }
    
    var text: String {
        switch self {
        case .logout: return "로그아웃을 하더라도 모든 정보는 저장되며,\n언제든 다시 로그인이 가능합니다."
        case .exitReading: return "지금까지 읽은 동화와 퀴즈는 전부 저장되며,\n홈을 통해 언제든지 다시 읽어볼 수 있어요."
        case .deleteAccount: return "탈퇴를 진행하면 모든 독서 생성 기록 및 도토리\n갯수가 초기화되며, 다시 복구할 수 없습니다."
        }
    }
}

struct QuestionModal: View {
    let type: QuestionType
    let onCancel: () -> Void
    let onConfirm: () -> Void
    
    var body: some View {
        ZStack {
            Color.tBlack.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    onCancel()
                }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(type.title)
                    .font(.NotoSans_20_SB)
                    .foregroundStyle(type.titleColor)
                    .padding(.bottom, 10)
                
                Text(type.text)
                    .font(.NotoSans_16_R)
                    .foregroundStyle(.tBlack)
                    .padding(.bottom, 20)
                
                HStack(spacing: 10) {
                    CTAButton(
                        title: "아니요",
                        type: .gray,
                        width: 151.5,
                        action: {
                            onCancel()
                        }
                    )
                    
                    CTAButton(
                        title: "예",
                        width: 151.5,
                        action: {
                            onConfirm()
                        }
                    )
                }
            }
            .padding(20)
            .background(.white)
            .cornerRadius(26)
        }
    }
}

#Preview{
    QuestionModal(type: .logout, onCancel: {}, onConfirm: {})
}
