//
//  WordLearningView.swift
//  Totori
//
//  Created by 복지희 on 2/21/26.
//

import SwiftUI

struct WordLearningView: View {

    // MARK: - Model

    struct WordItem: Identifiable, Equatable {
        let id = UUID()
        let text: String
    }

    // MARK: - Sample Inputs

    private let words: [WordItem] = [
        .init(text: "응원"),
        .init(text: "당연"),
        .init(text: "긍정"),
        .init(text: "정원")
    ]
    private let progress: CGFloat = 0.25
    private let acornCount: Int = 1

    // MARK: - State

    @State private var selectedID: UUID? = nil
    @State private var isPlaying: Bool = false

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

            // 타이틀
            Text("먼저, 단어를 들어보자!")
                .font(.NotoSans_24_SB)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

            Spacer().frame(height: 40)

            // 단어 리스트
            VStack(spacing: 20) {
                ForEach(words) { item in
                    wordRow(
                        title: item.text,
                        isSelected: selectedID == item.id,
                        isPlaying: (selectedID == item.id) && isPlaying,
                        onTap: { handleTap(itemID: item.id) }
                    )
                }
            }
            .padding(.horizontal, 20)

            Spacer()
            
            // 도토리 획득 상황
            acornRewards(count: acornCount)
            
            Spacer()

            // 다음 버튼
            CTAButton(title: "다음", type: .purple) {
                onNext()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 22)
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

    // MARK: - 단어 버튼

    @ViewBuilder
    private func wordRow(
        title: String,
        isSelected: Bool,
        isPlaying: Bool,
        onTap: @escaping () -> Void
    ) -> some View {
        Button(action: onTap) {
            HStack(spacing: 10) {

                Image(isPlaying ? .pause : .play)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)

                Spacer()

                Text(title)
                    .font(.NotoSans_30_B)
                    .foregroundStyle(.black)

                Spacer()

                // 좌우 균형용 더미 공간
                Color.clear.frame(width: 50)
            }
            .padding(.vertical, 10)
            .frame(height: 62)
            .background(isSelected ? Color.point : Color.tGray)
            .clipShape(RoundedRectangle(cornerRadius: 26))
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - 도토리 획득 상황
    
    @ViewBuilder
    private func acornRewards(count: Int) -> some View {
        HStack(spacing: 10) {
            ForEach(0..<3, id: \.self) { index in
                Image(index < count ? .acornActive : .acronInactive)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
        }
    }

    // MARK: - Actions / Logic

    // 단어버튼 선택 로직
    private func handleTap(itemID: UUID) {
        if selectedID == itemID {
            // 같은 row 다시 누르면 play/pause 토글
            isPlaying.toggle()
        } else {
            // 다른 row 선택
            selectedID = itemID
            isPlaying = true
        }

        // TODO: 실제 오디오 로직 연결
        // if isPlaying { play(itemID) } else { pause(itemID) }
    }

    // 다음 화면/다음 단계 이동
    private func onNext() {
        
    }
}

#Preview {
    WordLearningView()
}
