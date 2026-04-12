//
//  MyPageMain.swift
//  Totori
//
//  Created by 복지희 on 2/28/26.
//

import SwiftUI

struct MyPageMainView: View {
    
    @StateObject private var viewModel = MyPageMainViewModel()
    
    @State private var showPopOver = false
    @State private var goBadgeList = false
    @State private var goConnect = false
    
    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 3
    )
    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                
                CustomNavigationBar(
                    centerType: .textLogo,
                    showsBackButton: true
                )
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        profileCard
                            .zIndex(showPopOver ? 10 : 1)
                        
                        BadgeCard(
                            title: viewModel.badgeTitle,
                            subtitle: viewModel.badgeSubTitle,
                            progress: viewModel.progress,
                            imageUrl: viewModel.imageUrl,
                            onTap: {
                                goBadgeList = true
                            }
                        )
                        .navigationDestination(isPresented: $goBadgeList) {
                            MyPageBadgeView()
                                .navigationBarBackButtonHidden(true)
                        }
                        
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(viewModel.badges) { badge in
                                BadgeGridCell(badge: badge)
                                    .onTapGesture {
                                        // TODO: 뱃지 상세/획득 팝업 등
                                    }
                            }
                        }
                        .padding(.bottom, 80)
                    }
                    .padding(20)
                }
            }
            .background(.main20)
            .navigationDestination(isPresented: $goConnect) {
                ConnectView(viewModel: ConnectViewModel(role: .child))
            }
            
            if showPopOver {
                Color.clear
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showPopOver = false
                        }
                    }
            }
        }
    }
    
    // MARK: - Profile Card
    
    private var profileCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26)
                .fill(Color.white)
            
            VStack(spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    // TODO: 프로필 이미지로 변경
                    Circle()
                        .fill(Color.tGray)
                        .frame(width: 113, height: 113)
                    
                    // 수정버튼
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showPopOver.toggle()
                        }
                    } label: {
                        Circle()
                            .fill(Color.textGray)
                            .frame(width: 33, height: 33)
                            .overlay(
                                Image(.editPencil)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                            )
                    }
                    .buttonStyle(.plain)
                    .overlay(alignment: .top) {
                        if showPopOver {
                            PopOverContent{
                                showPopOver = false
                                goConnect = true
                            }
                            .offset(y: 54)
                        }
                    }
                }
                .zIndex(1)
                
                Text(viewModel.userName)
                    .font(.NotoSans_24_SB)
                    .foregroundStyle(Color.tBlack)
                    .zIndex(0)
                    .padding(.top, 8)
                    .padding(.bottom, 15)
                
                HStack(spacing: 4) {
                    statCardAcorn(value: "\(viewModel.totalAcorn)개")
                    statCardBook(value: "\(viewModel.readBookCount)권")
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 30)
            .padding(.bottom, 20)
            
            if showPopOver {
                Color.clear
                    .contentShape(Rectangle())
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showPopOver = false
                        }
                    }
            }
        }
    }
    
    // MARK: - Popover Card
    
    struct PopOverContent: View {
        let onConnect: () -> Void
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                menuButton(
                    title: "프로필 사진 변경",
                    color: .tBlack) {
                        print("사진 변경 클릭")
                    }
                
                menuButton(
                    title: "기본 이미지로 변경",
                    color: .tBlack) {
                        print("기본 이미지 클릭")
                    }
                
                Divider().background(Color.tGray)
                
                menuButton(
                    title: "보호자와 연결하기",
                    color: .mainVariation,
                    isAdd: true) {
                        onConnect()
                    }
            }
            .frame(width: 201)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 0)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.tGray, lineWidth: 1)
            )
        }
        
        @ViewBuilder
        private func menuButton(
            title: String,
            color: Color,
            isAdd: Bool = false,
            action: @escaping () -> Void
        ) -> some View {
            Button(action: action) {
                HStack(spacing: 15) {
                    if isAdd {
                        Image(.plusButton)
                    }
                    Text(title)
                        .font(.NotoSans_16_R)
                }
                .foregroundColor(color)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - Stat Cards
    
    private struct statCardAcorn: View {
        
        let value: String
        
        var body: some View {
            
            ZStack {
                RoundedRectangle(cornerRadius: 26)
                    .fill(Color.main20)
                
                VStack(spacing: 0) {
                    Text("모은 도토리")
                        .font(.NotoSans_14_R)
                        .foregroundStyle(.mainVariation)
                    
                    HStack(alignment: .center, spacing: 6) {
                        Circle()
                            .fill(.white)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(.icLogoPurple)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            )
                        
                        Text(value)
                            .font(.NotoSans_30_SB)
                            .foregroundStyle(Color.tBlack)
                            .frame(height: 50)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
    }
    
    private struct statCardBook: View {
        
        let value: String
        
        var body: some View {
            
            ZStack {
                RoundedRectangle(cornerRadius: 26)
                    .fill(.point20)
                
                VStack(spacing: 0) {
                    Text("읽은 이야기")
                        .font(.NotoSans_14_R)
                        .foregroundStyle(.mainVariation)
                    
                    HStack(alignment: .center, spacing: 6) {
                        Circle()
                            .fill(.white)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(.badgeIcon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            )
                        
                        Text(value)
                            .font(.NotoSans_30_SB)
                            .foregroundStyle(Color.tBlack)
                            .frame(height: 50)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
    }
}

#Preview {
    MyPageMainView()
}
