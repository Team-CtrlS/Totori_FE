//
//  BadgeGridCell.swift
//  Totori
//
//  Created by 복지희 on 2/28/26.
//

import SwiftUI

import Kingfisher

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
            
            KFImage(URL(string: badge.imageUrl))
                .placeholder {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                }
                .resizable()
                .grayscale(badge.isUnlocked ? 0 : 1)
                .scaledToFit()
                .frame(height: 89)
                .padding(15)
        }
        .shadow(color: Color.black.opacity(0.01), radius: 20, x: 0, y: 4)
    }
}
