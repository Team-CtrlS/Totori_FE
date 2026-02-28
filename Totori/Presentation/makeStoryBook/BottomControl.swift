//
//  BottomControl.swift
//  Totori
//
//  Created by 정윤아 on 2/27/26.
//

import SwiftUI

// MARK: - Types

enum CenterType: Equatable {
    case speak
    case listening(isRecording: Bool)
    case acorn
    case processing
    
    var circleColor: Color {
        switch self {
        case .listening, .speak: return .point
        case .acorn: return .white
        case .processing: return .clear
        }
    }
    
    var iconImage: Image? {
        switch self {
        case .listening: return Image(.mic)
        case .speak: return Image(.soundWave1)
        case .acorn: return Image(.icLogoPurple)
        case .processing: return nil
        }
    }
    
    var hasWaveAnimation: Bool {
        switch self {
        case .listening(let isRecording): return isRecording
        default: return false
        }
    }
}

struct BottomControl: View {
    let type: CenterType
    
    var onCenterTap: (() -> Void)? = nil
    var onPrevTap: (() -> Void)? = nil
    
    @State private var isAnimating: Bool = false
    
    var body: some View {
        VStack {
            centerButtonView
            
            Spacer()
            
            HStack {
                Button(action: { onPrevTap?() }) {
                    Image(.circleLeft)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            .padding(.leading, 20)
        }
    }
    
    @ViewBuilder
    private var centerButtonView: some View {
        if type != .processing {
            Button(action: { onCenterTap?() }) {
                ZStack {
                    if type.hasWaveAnimation {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .stroke(Color.point.opacity(0.5), lineWidth: 13)
                                .frame(width: 80, height: 80)
                                .scaleEffect(isAnimating ? 2.0 : 1.0)
                                .opacity(isAnimating ? 0.0 : 1.0)
                                .animation(
                                    Animation.easeOut(duration: 2.0)
                                        .repeatForever(autoreverses: false)
                                        .delay(Double(index) * 0.5),
                                    value: isAnimating
                                )
                        }
                    }
                    
                    Circle()
                        .fill(type.circleColor)
                        .frame(width: 80, height: 80)
                    
                    if let icon = type.iconImage {
                        icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                }
            }
            .buttonStyle(.plain)
            .onAppear {
                startAnimationIfNeeded()
            }
            .onChange(of: type) { _, _ in
                startAnimationIfNeeded()
            }
        } else {
            EmptyView()
        }
    }
    
    private func startAnimationIfNeeded() {
        if type.hasWaveAnimation {
            isAnimating = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isAnimating = true
            }
        } else {
            isAnimating = false
        }
    }
}
