//
//  BookBottomControl.swift
//  Totori
//
//  Created by 복지희 on 2/18/26.
//

import SwiftUI

enum CenterControlType {
    case speaker
    case mic
    case micRinging
    case none

    var isHidden: Bool {
        if case .none = self { return true }
        return false
    }

    var assetImage: Image? {
        switch self {
        case .speaker:
            return Image("sound_wave_2")
        case .mic, .micRinging:
            return Image("mic")
        case .none:
            return nil
        }
    }

    var roundColor: Color {
        switch self {
        case .speaker:
            return .point
        case .mic:
            return .main
        case .micRinging:
            return .point
        case .none:
            return .clear
        }
    }

    // 마이크 파동 여부
    var showsRinging: Bool {
        if case .micRinging = self { return true
        }
        return false
    }
}

enum NavDirection {
    case prev
    case next

    var assetImage: Image {
        switch self {
        case .prev:
            return Image("circle_left")
        case .next:
            return Image("circle_right")
        }
    }
}

// MARK: - Bottom Controls

struct BookBottomControls: View {

    let centerType: CenterControlType
    // 활성화 여부
    let isPrevEnabled: Bool
    let isNextEnabled: Bool

    let onTapPrev: () -> Void
    let onTapNext: () -> Void
    let onTapCenter: () -> Void

    init(
        centerType: CenterControlType,
        isPrevEnabled: Bool = true,
        isNextEnabled: Bool = true,
        onTapPrev: @escaping () -> Void,
        onTapNext: @escaping () -> Void,
        onTapCenter: @escaping () -> Void = {}
    ) {
        self.centerType = centerType
        self.isPrevEnabled = isPrevEnabled
        self.isNextEnabled = isNextEnabled
        self.onTapPrev = onTapPrev
        self.onTapNext = onTapNext
        self.onTapCenter = onTapCenter
    }

    var body: some View {
        HStack {
            
            // 왼쪽 화살표
            CircleNavButton(
                direction: .prev,
                isEnabled: isPrevEnabled,
                action: onTapPrev
            )
            
            Spacer()

            if !centerType.isHidden {
                CenterActionButton(
                    type: centerType,
                    action: onTapCenter
                )
            }
            
            Spacer()

            // 오른쪽 화살표
            CircleNavButton(
                direction: .next,
                isEnabled: isNextEnabled,
                action: onTapNext
            )
        }
    }
}

// MARK: - Circle Nav Button

struct CircleNavButton: View {

    let direction: NavDirection
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            direction.assetImage
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)
                .opacity(isEnabled ? 1 : 0.5)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}

// MARK: - Center Button

struct CenterActionButton: View {

    let type: CenterControlType
    let action: () -> Void

    private let size: CGFloat = 80

    var body: some View {
        Button(action: action) {
            ZStack {

                // 울림 애니메이션 (녹음 중일 때만)
                if type.showsRinging {
                    Circle()
                        .fill(type.roundColor.opacity(0.8))
                        .frame(width: size + 150, height: size)
                        .scaleEffect(1.15)
                        .opacity(0.3)
                        .animation(
                            .easeOut(duration: 0.9)
                                .repeatForever(autoreverses: true),
                            value: type
                        )
                }

                // 메인 원
                Circle()
                    .fill(type.roundColor)
                    .frame(width: size, height: size)

                // 아이콘
                if let image = type.assetImage {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
