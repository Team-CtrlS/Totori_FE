//
//  MyPageBadgeView.swift
//  Totori
//
//  Created by 복지희 on 3/1/26.
//

import SwiftUI

struct MyPageBadgeView: View {

    @StateObject private var viewModel = MyPageBadgeViewModel()

    var body: some View {
        VStack(spacing: 0) {

            CustomNavigationBar(centerType: .text("도토리 전시장"))

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    topSummaryCard
                        .padding(.horizontal, 20)
                        .padding(.top, 16)

                    BadgeCard(
                        title: viewModel.closestBadgeTitle,
                        subtitle: viewModel.closestBadgeSubtitle,
                        progress: viewModel.closestBadgeProgress,
                        onTap: { print("현재 뱃지 상세 이동") }
                    )
                    .padding(.horizontal, 20)

                    // 뱃지 리스트
                    VStack(spacing: 0) {
                        Spacer().frame(height: 20)
                        ForEach(viewModel.items) { item in
                            BadgeListCell(badge: item)

                            Divider()
                                .padding(.horizontal, 20)
                        }
                        Spacer().frame(height: 20)
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .background(Color.background.ignoresSafeArea())
    }

    // MARK: - Top Card

    private var topSummaryCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26)
                .fill(Color.white)

            VStack(spacing: 10) {

                // TODO: 뱃지 url 맞춰서 수정 필요
                Image(.badgeDefault)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)

                Text(viewModel.summayTitle)
                    .font(.NotoSans_24_SB)
                    .foregroundStyle(Color.main)

                ProgressBar(
                    progress: viewModel.summaryProgress,
                    height: .h12,
                    style: .gradient,
                    backColor: .lightgray
                )
                .padding(.horizontal, 20)

                Text(viewModel.progressText)
                    .font(.NotoSans_16_SB)
                    .foregroundStyle(Color.point)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    MyPageBadgeView()
}
