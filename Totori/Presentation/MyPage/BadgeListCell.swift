
//
//  BadgeListCell.swift
//  Totori
//
//  Created by user on 3/1/26.
//

import SwiftUI

import Kingfisher

struct BadgeListCell: View {
    let badge: BadgeListItem
    
    private var progressStyle: ProgressBarStyle {
            badge.isUnlocked ? .gray : .pink
    }
    
    var body: some View {
        HStack(spacing: 10) {
            
            KFImage(URL(string: badge.imageUrl))
                .placeholder {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .frame(width: 60, height: 60)
                }
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(badge.title)
                    .font(.NotoSans_16_SB)
                    .foregroundColor(.tBlack)
                
                Text(badge.subtitle)
                    .font(.NotoSans_12_R)
                    .foregroundColor(.textGray)
                    .padding(.bottom, 6)
                
                ProgressBar(
                    progress: CGFloat(badge.progress),
                    height: .h6,
                    style: progressStyle
                )
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
}
