//
//  CTAButton.swift
//  Totori
//
//  Created by 정윤아 on 2/15/26.
//

import SwiftUI

enum CTAStyle {
    case purple
    case pink
    case backgroundColor
    case gray
    
    var backgroundColor: Color {
        switch self {
        case .purple: return .main
        case .pink: return .point
        case .backgroundColor: return .background
        case .gray: return .tGray
        }
    }
    
    var titleColor: Color {
        switch self {
        case .purple, .pink: return .white
        case .backgroundColor, .gray: return .tBlack
        }
    }
}

struct CTAButton: View {
    
    // MARK: - Properties
    
    let title: String
    let type: CTAStyle
    let width: CGFloat
    let action: () -> Void
    
    // MARK: - Init
    
    init(
        title: String,
        type: CTAStyle = .purple,
        width: CGFloat = 353,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.type = type
        self.width = width
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.NotoSans_16_SB)
                .foregroundColor(type.titleColor)
                .frame(width: width)
                .frame(height: 42)
                .background(type.backgroundColor)
                .cornerRadius(14)
        }
    }
}
