//
//  MainView.swift
//  Totori
//
//  Created by 정윤아 on 2/24/26.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    @State private var navigateToMyPage: Bool = false
    @State private var navigateToBadgeInfo: Bool = false
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        ZStack {
            Color.main20.ignoresSafeArea()
            
            VStack(spacing: 0) {
                CustomNavigationBar(centerType: .logo, showsBackButton: false)
                    .zIndex(1)
                
                ScrollView {
                    VStack(spacing: 0) {
                        
                        // TODO: - 컴포넌트로 변경(트로피 있/없)
                        HStack {
                            ChipView(type: .profile(
                                name: viewModel.userName,
                                imageURL: viewModel.userImage),
                                     action: {
                                navigateToMyPage = true
                            }
                            )
                            
                            Spacer()
                            
                            HStack(spacing: 10) {
                                ChipView(type: .trophy)
                                ChipView(type: .acorn(amount: viewModel.acornCount))
                                ChipView(type: .question)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                        .background(.white)
                        
                        FeaturedBookCard(book: viewModel.featuredBook)
                        
                        // TODO: - 페이지 연결
                        BadgeCard(
                            title: viewModel.goalTitle,
                            subtitle: viewModel.goalSubtitle,
                            progress: viewModel.goalProgress,
                            onTap: {
                                navigateToBadgeInfo = true
                            }
                        )
                        .padding(20)
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            NavigationLink(
                                destination: makeStoryBookView()
                                .navigationBarBackButtonHidden(true)
                            ) {
                                    StoryBookView(type: .create(title: "이야기 시작하기"))
                                }
                                .buttonStyle(.plain)
                            
                            ForEach(0..<viewModel.storyBooks.count, id: \.self) { index in
                                let bookType = viewModel.storyBooks[index]
                                
                                NavigationLink(
                                    destination: BookInfoView()                                        .navigationBarBackButtonHidden(true)
                                ) {
                                    StoryBookView(type: bookType)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 33)
                        .padding(.bottom, 40)
                        
                    }
                }
            }
        }
        .navigationDestination(isPresented: $navigateToMyPage) {
            MyPageMainView()
                .navigationBarBackButtonHidden(true)
        }
        .navigationDestination(isPresented: $navigateToBadgeInfo) {
            MyPageBadgeView()
                .navigationBarBackButtonHidden(true)
        }
    }
}

struct FeaturedBookCard: View {
    let book: FeaturedBook
    
    var body: some View {
        HStack(spacing: 16) {
            
            if let urlString = book.coverURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 119, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 119, height: 180)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                
                Image(.logoFlatPurple)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 46, height: 11.06)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(book.title)
                        .font(.NotoSans_20_SB)
                        .foregroundColor(.mainVariation)
                    
                    Text(book.subtitle)
                        .font(.NotoSans_14_R)
                        .foregroundColor(.textGray)
                    
                }
                .padding(.bottom, 13)
                
                AcornRewards(count: book.rewardCount)
                    .padding(.bottom, 4)
                
                ProgressBar(progress: book.progress, height: .h6, style: .purple)
                
                HStack(spacing: 10) {
                    
                    Spacer()
                    
                    HStack(alignment: .center, spacing: 2) {
                        Image(.bookmark)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .offset(y: 2)
                        
                        Text("\(book.currentBookmark)/\(book.totalBookmark)")
                            .font(.NotoSans_14_R)
                            .foregroundColor(.textGray)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(.rect(bottomLeadingRadius: 26, bottomTrailingRadius: 26))
    }
}

#Preview {
    MainView()
}
