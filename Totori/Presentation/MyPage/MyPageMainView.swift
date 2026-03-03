//
//  MyPageMain.swift
//  Totori
//
//  Created by 복지희 on 2/28/26.
//

import SwiftUI

struct MyPageMainView: View {

    @StateObject private var viewModel = MyPageMainViewModel()
    
    @State private var showPopover = false
    @State private var goBadgeList = false

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
                ) {
                    Button {
                        print("설정 화면 이동")
                    } label: {
                        Image(.setting)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }

                ScrollView(showsIndicators: false) {
                    VStack() {

                        // backgroundColor 부분
                        VStack(spacing: 20) {
                            profileCard
                                .zIndex(showPopover ? 10 : 1)
                            
                            HStack(spacing: 14) {
                                statCard(
                                    value: "\(viewModel.totalAcorn)개",
                                    style: .acorn
                                )
                                statCard(
                                    value: "\(viewModel.readBookCount)권",
                                    style: .book
                                )
                            }

                            BadgeCard(
                                title: viewModel.badgeTitle,
                                subtitle: viewModel.badgeSubTitle,
                                progress: viewModel.progress,
                                onTap: {
                                    goBadgeList = true
                                }
                            )
                            .navigationDestination(isPresented: $goBadgeList) {
                                MyPageBadgeView()
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .background(Color.background)

                        // 뱃지 리스트
                        Text("뱃지 전시장")
                            .font(.NotoSans_16_SB)
                            .foregroundColor(Color.tBlack)
                            .padding(.top, 12)
                            .padding(.bottom, 32)

                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(viewModel.badges) { badge in
                                BadgeGridCell(badge: badge)
                                    .onTapGesture {
                                        // TODO: 뱃지 상세/획득 팝업 등
                                    }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 80)
                    }
                }
            }
            .background(Color.white.ignoresSafeArea())
            
            if showPopover {
                Color.white.opacity(0.001) // 투명하지만 터치는 인식됨
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showPopover = false
                        }
                    }
            }
        }
    }

    // MARK: - Profile Card

    private var profileCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white)

            VStack() {
                ZStack(alignment: .bottomTrailing) {
                    // TODO: 프로필 이미지로 변경
                    Circle()
                        .fill(Color.tGray)
                        .frame(width: 150, height: 150)
                    
                    // 수정버튼
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showPopover.toggle()
                        }
                    } label: {
                        Circle()
                            .fill(Color.textGray)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(.editPencil)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                            )
                    }
                    .buttonStyle(.plain)
                    .overlay(alignment: .top) {
                        if showPopover {
                            PopoverContent()
                                .offset(y: 54)
                        }
                    }
                }
                .zIndex(1)

                Text(viewModel.userName)
                    .font(.NotoSans_24_SB)
                    .foregroundStyle(Color.tBlack)
                    .zIndex(0)
            }
            .padding(.vertical, 40)
            
            if showPopover {
                Color.clear
                    .onTapGesture {
                        showPopover = false
                    }
                    .ignoresSafeArea()
            }
        }
    }
    
    // MARK: - Popover Card

    struct PopoverContent: View {
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
                    print("보호자 연결 클릭")
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
            action: @escaping () -> Void)
        -> some View {
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
    
    private struct statCard: View {

        enum Style {
            case acorn
            case book
            
            var backgroundColor: Color{
                switch self {
                case .acorn:
                    return Color.main60
                case .book:
                    return Color.point50
                }
            }
            
            var iconImage: Image {
                switch self {
                case .acorn:
                    return Image(.icLogoPurple)
                case .book:
                    return Image(.badgeIcon)
                }
            }
            
            var title: String {
                switch self {
                case .acorn:
                    return "모은 도토리"
                case .book:
                    return "읽은 이야기"
                }
            }
        }

        let value: String
        let style: Style

        var body: some View {

            ZStack {
                RoundedRectangle(cornerRadius: 26)
                    .fill(style.backgroundColor)
                
                VStack(spacing: 0) {
                    Text(style.title)
                        .font(.NotoSans_12_R)
                        .foregroundStyle(Color.gray)
                    
                    HStack(alignment: .center, spacing: 0) {
                        style.iconImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                        Text(value)
                            .font(.NotoSans_30_B)
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
