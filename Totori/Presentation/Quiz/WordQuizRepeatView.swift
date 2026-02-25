//
//  WordQuizRepeatView.swift
//  Totori
//
//  Created by 복지희 on 2/23/26.
//

import SwiftUI

// 화면 종류 3가지
enum WordQuizStage {
    case mic
    case success
    case fail

    var cardColor: Color {
        switch self {
        case .mic:
            return .point50
        case .success:
            return .main40
        case .fail:
            return .tGray
        }
    }

    var centerIcon: Image {
        switch self {
        case .mic:
            return Image(.mic)
        case .success:
            return Image(.check)
        case .fail:
            return Image(.retryWhite)
        }
    }
    
    var centerIconColor: Color {
        switch self {
        case .mic:
            return .point
        case .success:
            return .main
        case .fail:
            return .textGray
        }
    }
    
    var isMicEnabled: Bool { self == .mic }
}

struct WordQuizRepeatView: View {

    @State private var stage: WordQuizStage = .mic

    // MARK: - Sample Inputs
    private let word: String = "응원"
    private let acornCount: Int = 1
    
    var onTapCenter: (() -> Void)? = nil
    var onPrev: (() -> Void)? = nil
    var onNext: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            
            // 헤더 (칩 + 프로그레스바)
            header(
                name: "김밤톨",
                profileUrl: "https://picsum.photos/100",
                acornAmount: 10,
                progress: 0.4
            )
            .padding(.horizontal, 20)

            Spacer().frame(height: 60)

            Text("이제 차례대로 소리 내어 읽어볼까?")
                .font(.NotoSans_24_SB)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

            Spacer().frame(height: 40)

            // 단어 카드
            RoundedRectangle(cornerRadius: 26)
                .fill(stage.cardColor)
                .frame(height: 162)
                .overlay(
                    Text(word)
                        .font(.NotoSans_30_B)
                        .foregroundStyle(.black)
                )
                .padding(.horizontal, 20)

            Spacer()

            // 원형 버튼
            centerActionButton

            Spacer()

            // 도토리 획득 상황
            acornRewards(count: acornCount)

            Spacer()

            // 하단 이동 버튼
            BookBottomControls(
                centerType: .none,
                isPrevEnabled: true,
                isNextEnabled: true,
                onTapPrev: { onPrev },
                onTapNext: { onNext }
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 60)
            
        }
        .background(Color.white.ignoresSafeArea())
    }

    // MARK: - Header

    @ViewBuilder
    private func header(
        name: String,
        profileUrl: String,
        acornAmount: Int,
        progress: CGFloat
    ) -> some View {
        VStack(spacing: 20) {
            HStack {
                ChipView(type: .profile(name: name, imageURL: profileUrl))

                Spacer()
                
                HStack(spacing: 10) {
                    ChipView(type: .acorn(amount: acornAmount))
                    ChipView(type: .question)
                }
            }

            ProgressBar(
                progress: progress,
                height: .h8,
                style: .purple,
                backColor: .gray
            )
        }
    }

    // MARK: - Center Button

    private var centerActionButton: some View {
        let size: CGFloat = 80
        let isEnabled = (stage == .mic) || (stage == .fail)
        
        return Button {
            handleCenterTap()
        } label: {
            ZStack {
                Circle()
                    .fill(stage.centerIconColor)
                    .frame(width: size, height: size)

                stage.centerIcon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
        }
        .buttonStyle(.plain)
        .allowsHitTesting(isEnabled)
    }

    // MARK: - 도토리 획득 상황
    
    @ViewBuilder
    private func acornRewards(count: Int) -> some View {
        HStack(spacing: 10) {
            ForEach(0..<3, id: \.self) { index in
                Image(index < count ? .acornActive : .acornInactive)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
        }
    }
    
    // MARK: - Actions

    private func handleCenterTap() {
        switch stage {
        case .mic:
            // TODO: 나중에 STT/TTS 판정 결과로 분기 (일단 임시로 무조건 성공으로 이동하도록 설정)
            stage = .success

        case .fail:
            stage = .mic

        case .success:
            break
        }
    }
}

#Preview {
    WordQuizRepeatView()
}
