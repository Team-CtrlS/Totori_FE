//
//  BadgeEarnedView.swift
//  Totori
//
//  Created by 복지희 on 2/26/26.
//

import SwiftUI

struct BadgeEarnedView: View {
    
    // MARK: - State
    @StateObject private var viewModel = BadgeEarnedViewModel()

    var body: some View {
        ZStack {
            // 배경
            LinearGradient(
                colors: [Color.point, Color.main],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                // TODO: 뱃지 이미지 viewModel에서 받아온 imageUrl값의 이미지 사용하도록 수정
                Image(.badgeMixed)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(Color.white, lineWidth: 7.5)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 30, x: 0, y: 0)

                titleCard

                CTAButton(title: "닫기", type: .purple60) {
                    print("닫기 버튼 실행")
                }

                Spacer()
            }
        }
    }

    // MARK: - Title Card

    private var titleCard: some View {
        let boxWidth: CGFloat = 353
        
        return VStack(spacing: 10) {
            Text(viewModel.title)
                .font(.NotoSans_30_B)
                .foregroundStyle(Color.mainVariation)

            Text(viewModel.description)
                .font(.NotoSans_16_R)
                .foregroundStyle(Color.textGray)
        }
        .frame(width: boxWidth)
        .padding(.vertical, 20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 26))
    }

}

#Preview {
    BadgeEarnedView()
}
