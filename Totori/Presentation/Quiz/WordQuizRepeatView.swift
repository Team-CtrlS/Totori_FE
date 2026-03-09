//
//  WordQuizRepeatView.swift
//  Totori
//
//  Created by 복지희 on 2/23/26.
//

import SwiftUI

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
}

struct WordQuizRepeatView: View {
    
    let successQuizCount: Int

    // MARK: - State
    @ObservedObject var viewModel = WordViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                // 헤더 (칩 + 프로그레스바)
                header(
                    name: viewModel.userName,
                    profileUrl: viewModel.profileUrl,
                    acornAmount: viewModel.acornCount,
                    progress: viewModel.progress
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
                    .fill(viewModel.stage.cardColor)
                    .frame(height: 162)
                    .overlay(
                        Text(viewModel.currentWord)
                            .font(.NotoSans_30_B)
                            .foregroundStyle(.black)
                    )
                    .padding(.horizontal, 20)

                Spacer()

                centerActionButton

                Spacer()

                AcornRewards(count: successQuizCount)

                Spacer()

                BookBottomControls(
                    centerType: .none,
                    isPrevEnabled: viewModel.currentIndex > 0,
                    isNextEnabled: false,
                    onTapPrev: { print("이전") },
                    onTapNext: { print("다음") }
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 60)
                
            }
            .background(Color.white.ignoresSafeArea())

            // modal
            if viewModel.isShowingQuizModal {
                modalOverlay
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private var modalOverlay: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.isShowingQuizModal = false
                }
            
            if(!viewModel.isFinished){
                QuizModal(type: .retry(userName: viewModel.userName))
            } else {
                QuizModal(type: .perfect(userName: viewModel.userName))
            }
        }
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
        let isEnabled = (viewModel.stage == .mic) || (viewModel.stage == .fail)
        
        return Button {
            if viewModel.stage == .mic {
                // TODO: 실제 정답/실패 판단 api 호출로 변경. 임의로 랜덤 설정
                viewModel.checkAnswer(isCorrect: Bool.random())
            } else if viewModel.stage == .fail {
                viewModel.retryCurrentWord()
            }
        } label: {
            ZStack {
                Circle()
                    .fill(viewModel.stage.centerIconColor)
                    .frame(width: size, height: size)

                viewModel.stage.centerIcon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
        }
        .buttonStyle(.plain)
        .allowsHitTesting(isEnabled)
    }
}
