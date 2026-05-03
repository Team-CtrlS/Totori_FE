//
//  BookInfoView.swift
//  Totori
//
//  Created by 정윤아 on 2/28/26.
//

import SwiftUI

import Kingfisher

struct BookInfoView: View {
    @StateObject private var viewModel = BookInfoViewModel()
    
    let bookData: BookGenerateResponseDTO
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                CustomNavigationBar(
                    centerType: .textLogo,
                    showsBackButton: true
                )
                
                KFImage(URL(string: viewModel.coverImageUrl))
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                
                VStack (alignment: .leading, spacing: 10){
                    HStack {
                        Image(.logoFlatPurple)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 46, height: 11.06)
                        
                        Spacer()
                        
                        HStack(alignment: .center, spacing: 2) {
                            Image(.bookmark)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                                .offset(y: 2)
                            
                            Text("\(viewModel.progressText)")
                                .font(.NotoSans_14_R)
                                .foregroundColor(.textGray)
                        }
                    }
                    
                    Text("\(viewModel.bookTitle)")
                        .font(.NotoSans_24_SB)
                        .foregroundColor(.tBlack)
                    
                    ProgressBar(progress: viewModel.progressPercentage)
                        .padding(.bottom, 10)
                    
                    HStack {
                        Spacer()
                        
                        AcornRewards(count: viewModel.acornCount)
                    }
                    .padding(.bottom, 20)
                    
                    CTAButton(title: "이야기 읽기",
                              action: {
                        viewModel.tapReadStory()
                    })
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            viewModel.setupData(with: bookData)
        }
        .navigationDestination(isPresented: $viewModel.navigateToReadStoryBook) {
            if let data = viewModel.bookData {
                ReadStoryBookView(bookData: data)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}
