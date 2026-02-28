//
//  MyPageMain.swift
//  Totori
//
//  Created by 복지희 on 2/28/26.
//

import SwiftUI

struct ProfileBadgeView: View {

    @StateObject private var viewModel = MyPageMainViewModel()

    // 3열 그리드
    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 3
    )

    var body: some View {
        VStack(spacing: 0) {

            // TODO: 설정아이콘 우측에 추가
            CustomNavigationBar(
                centerType: .logo,
                showsBackButton: false
            )

            ScrollView(showsIndicators: false) {
                VStack() {

                    // backgroundColor 부분
                    VStack(spacing: 20) {
                        profileCard
                        
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
                                print("뱃지 리스트로 이동")
                            }
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .background(Color.background)

                    // 뱃지 리스트
                    Text("도토리 전시장")
                        .font(.NotoSans_16_SB)
                        .foregroundStyle(Color.tBlack)
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

                    // 연필 버튼
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

                Text(viewModel.userName)
                    .font(.NotoSans_24_SB)
                    .foregroundStyle(Color.tBlack)
            }
            .padding(.vertical, 40)
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
    ProfileBadgeView()
}
