//
//  MyPageBadgeView.swift
//  Totori
//
//  Created by 복지희 on 3/1/26.
//

import SwiftUI

import Kingfisher

struct MyPageBadgeView: View {

    let category: BadgeCategory
    let initialBadgeId: Int
    
    @StateObject private var viewModel = MyPageBadgeViewModel()

    var body: some View {
        VStack(spacing: 0) {

            CustomNavigationBar(centerType: .text("뱃지 전시장"))

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    topSummaryCard
                        .padding(.top, 16)

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
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            viewModel.fetchAll(category: category, initialBadgeId: initialBadgeId)
        }
        .background(Color.main20.ignoresSafeArea())
    }

    // MARK: - Top Card

    private var topSummaryCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26)
                .fill(Color.white)

            VStack(spacing: 10) {

                KFImage(URL(string: viewModel.summaryBadgeUrl))
                    .placeholder {
                        RoundedRectangle(cornerRadius: 21.1)
                            .fill(Color.white)
                            .frame(width: 100, height: 100)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .cornerRadius(21.1)

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
