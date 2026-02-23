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

    // 채워지는 색
    var fillColor: Color {
        switch self {
        case .purple: return .main
        case .pink:   return .point
        case .gray:   return .textGray
        case .gradient:
            // gradient는 fillColor 안 쓰지만, 컴파일 편의상 기본값
            return .main
        }
    }

    // 배경색
    var backgroundColor: Color {
        switch self {
        case .purple, .pink:
            return .tGray
        case .gray:
            return Color.black.opacity(0.06)
        case .gradient:
            return Color.black.opacity(0.08)
        }
    }

    // 그라데이션
    var gradient: LinearGradient {
        LinearGradient(
            colors: [.point, .main],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    var isGradient: Bool {
        if case .gradient = self { return true }
        return false
    }
}

// MARK: - Progress Bar

struct ProgressBar: View {
    
    let progress: CGFloat   // 0.0 ~ 1.0 사이 진척정도
    let height: ProgressBarHeight
    let style: ProgressBarStyle
    let cornerRadius: CGFloat

    init(
        progress: CGFloat,
        height: ProgressBarHeight = .h8,
        style: ProgressBarStyle = .purple,
        cornerRadius: CGFloat? = nil
    ) {
        self.progress = max(0, min(progress, 1)) // clamp
        self.height = height
        self.style = style
        self.cornerRadius = cornerRadius ?? height.value / 2
    }

    var body: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let fillWidth = totalWidth * progress

            ZStack(alignment: .leading) {

                // 트랙
                Capsule()
                    .fill(style.backgroundColor)

                // 프로그래스바
                if style.isGradient {
                    Capsule()
                        .fill(style.gradient)
                        .frame(width: fillWidth)
                } else {
                    Capsule()
                        .fill(style.fillColor)
                        .frame(width: fillWidth)
                }
            }
        }
        .frame(height: height.value) // width는 부모에 맞춤
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int(progress * 100)) percent")
    }
}
