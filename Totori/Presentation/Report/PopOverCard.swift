//
//  PopOverCard.swift
//  Totori
//
//  Created by 복지희 on 3/13/26.
//
import SwiftUI

enum ContentType {
    case wcpm
    case error
    
    var title: String {
        switch self {
        case .wcpm:
            return "WCPM(읽기 유창성)이란?"
        case .error:
            return "오답 유형 분석표"
        }
    }
    
    var descript: String {
        switch self {
        case .wcpm:
            return "현대에서 보편적으로 사용하는 유창성\n지표 중 하나로, 글을 얼마나 빠르고\n 정확하게 읽는지 나타냅니다."
        case .error:
            return "아동이 동화를 읽으면서 발생하는 발음의 오차 및 유형을 나타냅니다."
        }
    }
}

struct PopOverCard: View {
    let type: ContentType
    
    var body: some View {
        
        VStack(spacing: 6) {
            Image(.icLogoPurple)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            
            Text(type.title)
                .font(.NotoSans_14_SB)
                .foregroundStyle(.black)
            
            Text(type.descript)
                .font(.NotoSans_12_R)
                .foregroundStyle(.black)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(10)
        .frame(width: 205)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 0)
        )
    }
}
