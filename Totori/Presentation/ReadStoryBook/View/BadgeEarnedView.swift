//
//  BadgeEarnedView.swift
//  Totori
//
//  Created by 복지희 on 2/26/26.
//

import SwiftUI
import Kingfisher

struct BadgeEarnedView: View {
    
    @State private var navigateToEnd: Bool = false
    
    let completeResult: BookCompleteResponseDTO?
    let coverImageUrl: String

    // 첫 번째 획득 뱃지 정보
    private var badge: BadgeResponseDTO? {
        completeResult?.newlyAcquiredBadges.first
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.mainGradient, Color.pointGradient],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            GifImage("particle")
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                if let badgeUrl = badge?.imageUrl, let url = URL(string: badgeUrl) {
                    KFImage(url)
                        .placeholder { ProgressView() }
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.white, lineWidth: 7.5)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 30, x: 0, y: 0)
                } else {
                    Image(.badgeMixed)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.white, lineWidth: 7.5)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 30, x: 0, y: 0)
                }

                titleCard

                CTAButton(title: "닫기", type: .purple60) {
                    print("닫기 버튼 실행")
                    navigateToEnd = true
                }

                Spacer()
            }
        }
        .navigationDestination(isPresented: $navigateToEnd) {
            BookEndView(
                completeResult: completeResult,
                coverImageUrl: coverImageUrl
            )
            .navigationBarHidden(true)
        }
    }

    // MARK: - Title Card

    private var titleCard: some View {
        let boxWidth: CGFloat = 353
        
        return VStack(spacing: 10) {
            Text(badge?.name ?? "새로운 뱃지 획득!")
                .font(.NotoSans_30_B)
                .foregroundStyle(Color.mainVariation)

            Text("\(badge?.categoryName ?? "뱃지")를 획득했어요!")
                .font(.NotoSans_16_R)
                .foregroundStyle(Color.textGray)
        }
        .frame(width: boxWidth)
        .padding(.vertical, 20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 26))
    }
}
