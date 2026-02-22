//
//  ProgressBar.swift
//  Totori
//
//  Created by 복지희 on 2/18/26.
//

import SwiftUI

enum ProgressBarHeight {
    case h12
    case h8
    case h6

    var value: CGFloat {
        switch self {
        case .h12: return 12
        case .h8:  return 8
        case .h6:  return 6
        }
    }
}

enum ProgressBarStyle {
    case purple
    case pink
    case gray
    case gradient

    var shapeStyle: AnyShapeStyle {
        switch self {
        case .purple:
            return AnyShapeStyle(Color.main)
        case .pink:
            return AnyShapeStyle(Color.point)
        case .gray:
            return AnyShapeStyle(Color.textGray)
        case .gradient:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [.pointGradient, .mainGradient],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
        }
    }
}

enum BackgroundColor {
    case white
    case gray
    case lightgray
    
    var fillColor: Color {
        switch self {
        case .white: return .white
        case .gray: return .tGray
        case .lightgray: return .tLightGray
        }
    }
}

// MARK: - Progress Bar

struct TotoriProgressBar: View {

    let progress: CGFloat   // 0.0 ~ 1.0 사이 진척도
    let height: ProgressBarHeight
    let style: ProgressBarStyle
    let backColor: BackgroundColor

    init(
        progress: CGFloat,
        height: ProgressBarHeight = .h8,
        style: ProgressBarStyle = .purple,
        backColor: BackgroundColor = .gray
    ) {
        self.progress = max(0, min(progress, 1))
        self.height = height
        self.style = style
        self.backColor = backColor
    }

    var body: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let fillWidth = totalWidth * progress

            ZStack(alignment: .leading) {

                // 배경
                Capsule()
                    .fill(backColor.fillColor)

                // 진행 바
                Capsule()
                    .fill(style.shapeStyle)
                    .frame(width: fillWidth)
            }
        }
        .frame(height: height.value)
    }

}
