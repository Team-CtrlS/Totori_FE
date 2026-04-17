//
//  BadgeCard.swift
//  Totori
//
//  Created by 정윤아 on 2/24/26.
//

import SwiftUI

import Kingfisher

struct BadgeCard: View {
    let title: String
    let subtitle: String
    let progress: Double
    let imageUrl: String?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                if let urlString = imageUrl, let url = URL(string: urlString) {
                    KFImage(url)
                        .placeholder {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(width: 66, height: 66)
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .frame(width: 66, height: 66)
                }
                
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
                        style: .pink,
                        backColor: .white
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
