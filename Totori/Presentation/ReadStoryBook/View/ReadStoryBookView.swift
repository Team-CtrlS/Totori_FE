//
//  ReadStoryBookView.swift
//  Totori
//
//  Created by 정윤아 on 2/28/26.
//

import SwiftUI

import Kingfisher

struct ReadStoryBookView: View {
    @StateObject private var viewModel = ReadStoryBookViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var showModal: Bool = false
    @State private var navigateToStart: Bool = false
    
    private let source: ReadStoryBookSource
    
    init(bookData: BookGenerateResponseDTO) {
        self.source = .generated(bookData)
    }
    
    init(bookDetail: BookDetailResponseDTO) {
        self.source = .detail(bookDetail)
    }
    
    init(source: ReadStoryBookSource) {
        self.source = source
    }
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    showModal = true
                }) {
                    Image(.close)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(.top, 80)
                        .padding(.leading, 322)
                }
                Spacer()
            }
            .zIndex(2)
            
            VStack(spacing: 0) {
                KFImage(URL(string: viewModel.currentDisplayPage.imageUrl))
                    .placeholder {
                        ProgressView()
                    }
                    .retry(maxCount: 2, interval: .seconds(2))
                    .cacheMemoryOnly(false)
                    .fade(duration: 0.3)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 570)
                    .ignoresSafeArea()
                
                bottomSheetView
            }
            
            if showModal {
                QuestionModal(
                    type: .exitReading,
                    onCancel: { showModal = false },
                    onConfirm: {
                        showModal = false
                        navigateToStart = true
                    }
                )
            }
        }
        .onAppear {
            switch source {
            case .generated(let bookData):
                viewModel.setUpData(bookData: bookData)
            case .detail(let bookDetail):
                viewModel.setUpData(bookDetail: bookDetail)
            }
        }
        .navigationDestination(isPresented: $navigateToStart) {
            MainView()
                .navigationBarBackButtonHidden(true)
        }
        .navigationDestination(isPresented: $viewModel.navigateToBadge) {
            BadgeEarnedView()
                .navigationBarBackButtonHidden(true)
        }
        .navigationDestination(isPresented: $viewModel.navigateToFinish) {
            BookEndView()
                .navigationBarBackButtonHidden(true)
        }
        .navigationDestination(isPresented: $viewModel.navigateToQuiz) {
            WordLearningView(
                successQuizCount: 0,
                bookId: viewModel.bookId
            )
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private var bottomSheetView: some View {
        VStack {
            ProgressBar(progress: viewModel.progress)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
            Text("\(viewModel.currentDisplayPage.text)")
                .font(.NotoSans_24_R)
                .foregroundColor(.tBlack)
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    Rectangle()
                        .fill(viewModel.isTTSSpeaking ? Color.main20 : Color.clear)
                        .padding(20)
                )
                .onTapGesture {
                    viewModel.toggleTTS()
                }
            
            BookBottomControls(
                centerType: viewModel.centerControlType,
                isPrevEnabled: viewModel.isPrevEnabled,
                isNextEnabled: viewModel.isNextEnabled,
                onTapPrev: { viewModel.goPrev() },
                onTapNext: { viewModel.goNext() },
                onTapCenter: { viewModel.toggleMic() }
            )
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .frame(height: 330)
        .background(Color.white)
        .clipShape(
            .rect(
                topLeadingRadius: 30,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 30
            )
        )
        .ignoresSafeArea(edges: .bottom)
    }
}
