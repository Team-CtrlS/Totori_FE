//
//  Chip.swift
//  Totori
//
//  Created by 정윤아 on 2/20/26.
//

import SwiftUI

enum ChipType {
    case profile(name: String, imageURL: String?)
    case trophy
    case acron(amount: Int)
    case question
    
    var text: String? {
        switch self {
        case .profile(let name, _):
            return name
        case .acron(let amount):
            return "\(amount)"
        case .trophy, .question:
            return nil
        }
    }
    
    var verticalPadding: CGFloat {
        switch self {
        case .profile:
            return 5
        case .acron, .trophy, .question:
            return 8
        }
    }
}

struct ChipView: View {
    
    // MARK: - Properties
    
    let type: ChipType
    var action: (() -> Void)? = nil
    
    
    // MARK: - View
    
    var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: 4) {
                iconView
                
                if let text = type.text {
                    Text(text)
                        .font(.NotoSans_16_SB)
                        .foregroundColor(.tBlack)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, type.verticalPadding)
            .background(.white)
            .overlay(
                Capsule()
                    .stroke(.main40, lineWidth: 4)
            )
            .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - ViewBuilder
    
    @ViewBuilder
    private var iconView: some View {
        switch type {
        case .profile(_, let imageURL):
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Circle()
                        .fill(Color(white: 0.9))
                }
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.tLightGray)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
            
        case .trophy:
            Image(.achievement)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            
        case .acron(_):
            Image(.acronPurple)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            
        case .question:
            Image(.question)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        }
    }
}
