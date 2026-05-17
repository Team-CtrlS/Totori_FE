//
//  WordLearningView.swift
//  Totori
//
//  Created by 복지희 on 2/21/26.
//

import SwiftUI

struct WordLearningView: View {

    let successQuizCount: Int

    // MARK: - State
    @StateObject private var viewModel: WordViewModel

    @State private var selectedID: String? = nil
    @State private var isPlaying: Bool = false
    @State private var isNavigatingToQuiz: Bool = false

    // MARK: - Init

    init(successQuizCount: Int, bookId: Int) {
        self.successQuizCount = successQuizCount
        _viewModel = StateObject(wrappedValue: WordViewModel(bookId: bookId))
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {

                    header(
                        name: viewModel.userName,
                        profileUrl: viewModel.profileUrl,
                        acornAmount: viewModel.acornCount,
                        progress: viewModel.progress
                    )
                    .padding(.horizontal, 20)

                    Spacer().frame(height: 60)

                    Text("먼저, 단어를 들어보자!")
                        .font(.NotoSans_24_SB)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)

                    Spacer().frame(height: 40)

                    // 단어 리스트 or 로딩
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView("단어를 불러오는 중...")
                            .font(.NotoSans_24_R)
                        Spacer()
                    } else if let error = viewModel.errorMessage {
                        Spacer()
                        VStack(spacing: 16) {
                            Text(error)
                                .font(.NotoSans_24_R)
                                .foregroundColor(.textGray)
                            Button("다시 시도") {
                                viewModel.fetchQuiz()
                            }
                            .font(.NotoSans_24_SB)
                            .foregroundColor(.point)
                        }
                        Spacer()
                    } else {
                        VStack(spacing: 20) {
                            ForEach(viewModel.words, id: \.self) { item in
                                wordRow(
                                    title: item,
                                    isSelected: selectedID == item,
                                    isPlaying: (selectedID == item) && isPlaying,
                                    onTap: { handleTap(itemID: item) }
                                )
                            }
                        }
                        .padding(.horizontal, 20)

                        Spacer()

                        AcornRewards(count: successQuizCount)

                        Spacer()

                        CTAButton(title: "다음", type: .purple) {
                            viewModel.setupQuiz()
                            isNavigatingToQuiz = true
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 60)
                    }
                }
                .background(Color.white.ignoresSafeArea())
            }
            .onAppear {
                viewModel.fetchQuiz()
            }
            .navigationDestination(isPresented: $isNavigatingToQuiz) {
                WordQuizRepeatView(
                    successQuizCount: successQuizCount,
                    viewModel: viewModel
                )
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
            ProgressBar(progress: progress, height: .h8, style: .purple, backColor: .gray)
        }
    }

    // MARK: - Word Row

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
                Color.clear.frame(width: 50)
            }
            .padding(.vertical, 10)
            .frame(height: 62)
            .background(isSelected ? Color.point : Color.tGray)
            .clipShape(RoundedRectangle(cornerRadius: 26))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Actions

    private func handleTap(itemID: String) {
        if selectedID == itemID {
            isPlaying.toggle()
        } else {
            selectedID = itemID
            isPlaying = true
        }
    }
}
