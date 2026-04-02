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
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 26)
                        .stroke(outerStroke, lineWidth: 4)
                )
            
            RoundedRectangle(cornerRadius: 16)
                .fill(innerBackground)
                .frame(height: 89)
                .padding(15)

            Image(badge.isUnlocked ? .badgePurple : .badgeGray)
                .resizable()
                .scaledToFit()
                .frame(width: 66, height: 66)
                .padding(.horizontal, 6)
                .padding(.bottom, 6)
        }
        .shadow(color: Color.black.opacity(0.01), radius: 20, x: 0, y: 4)
    }
}
