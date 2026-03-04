//
//  BadgeGridCell.swift
//  Totori
//
//  Created by 복지희 on 2/28/26.
//

import SwiftUI

struct BadgeGridCell: View {
    let badge: BadgeItem
    
    var outerStroke: Color{
        switch badge.isUnlocked {
        case true:
            return Color.point
        case false:
            return Color.textGray
        }
    }
    
    var innerBackground: Color{
        switch badge.isUnlocked {
        case true:
            return Color.main40
        case false:
            return Color.tGray
        }
    }

    var body: some View {

        ZStack{
            RoundedRectangle(cornerRadius: 26)
                .stroke(outerStroke, lineWidth: 4)
                .background(Color.white)
                .frame(width: 112, height: 123)
            
            RoundedRectangle(cornerRadius: 16)
                .fill(innerBackground)
                .frame(width: 78, height: 89)
                .padding(13)

            VStack(spacing: 0) {
                // TODO: 뱃지 이미지 url로 변경
                Image(badge.isUnlocked ? .badgePurple : .badgeGray)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 66, height: 66)
                    .padding(.horizontal, 6)
                
                if !badge.isUnlocked {
                    ProgressBar(
                        progress: badge.progress,
                        height: .h6,
                        style: .purple,
                        backColor: .lightgray
                    )
                    .frame(width: 50)
                    .padding(.bottom, 6)
                } else {
                    Color.clear.frame(height: 6)
                }
            }
        }
        .shadow(color: Color.black.opacity(0.01), radius: 20, x: 0, y: 4)
    }
}
