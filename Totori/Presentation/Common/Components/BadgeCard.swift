//
//  BadgeCard.swift
//  Totori
//
//  Created by 정윤아 on 2/24/26.
//

import SwiftUI

struct BadgeCard: View {
    let title: String
    let subtitle: String
    let progress: Double
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                
                // TODO: - 뱃지 유형에 따라 뱃지 이미지 분기처리
                
                Image(.badgeWhite)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 66, height: 66)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(.NotoSans_18_SB)
                        .foregroundColor(.tBlack)
                    
                    Text(subtitle)
                        .font(.NotoSans_14_R)
                        .foregroundColor(.textGray)
                        .padding(.bottom, 6)
                    
                    ProgressBar(
                        progress: CGFloat(progress),
                        height: .h12,
                        style: .pink
                    )
                }
                
                Image(.rightPurple)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .padding(20)
            .background(.main40)
            .clipShape(RoundedRectangle(cornerRadius: 26))
        }
        .buttonStyle(.plain)
    }
}
