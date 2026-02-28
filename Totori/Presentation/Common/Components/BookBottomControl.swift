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
    case acorn
    case none
    
    var isHidden: Bool {
        if case .none = self { return true }
        return false
    }
    
    var assetImage: Image? {
        switch self {
        case .speaker:
            return Image(.soundWave2)
        case .mic, .micRinging:
            return Image(.mic)
        case .acorn:
            return Image(.icLogoPurple)
        case .none:
            return nil
        }
    }
    
    var roundColor: Color {
        switch self {
        case .speaker, .micRinging:
            return .point
        case .mic:
            return .main
        case .acorn:
            return .white
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
            return Image(.circleLeft)
        case .next:
            return Image(.circleRight)
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
                .frame(width: 50, height: 50)
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
    
    @State private var isAnimating: Bool = false
    
    private let size: CGFloat = 80
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // 울림 애니메이션 (녹음 중일 때만)
                if type.showsRinging {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .stroke(Color.point.opacity(0.3), lineWidth: 13)
                            .frame(width: 80, height: 80)
                            .scaleEffect(isAnimating ? 2.0 : 1.0)
                            .opacity(isAnimating ? 0.0 : 1.0)
                            .animation(
                                Animation.easeOut(duration: 3.0)
                                    .repeatForever(autoreverses: false)
                                    .delay(Double(index) * 0.5),
                                value: isAnimating
                            )
                    }
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
        .onAppear {
            updateAnimationState()
        }
        .onChange(of: type) { _, _ in
            updateAnimationState()
        }
    }
    
    private func updateAnimationState() {
            if type.showsRinging {
                isAnimating = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isAnimating = true
                }
            } else {
                isAnimating = false
            }
        }
}
