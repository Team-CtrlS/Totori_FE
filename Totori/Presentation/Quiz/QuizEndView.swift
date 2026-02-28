//
//  QuizEndView.swift
//  Totori
//
//  Created by 복지희 on 2/26/26.
//

import SwiftUI

struct QuizEndView: View {

    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            Image(.profileSmile)
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 170)

            cardSection
                .padding(.horizontal, 20)

            // TODO: home navigate
            CTAButton(title: "홈으로", type: .purple) {
                print("홈으로 이동")
            }
            .padding(.horizontal, 20)
            
            Spacer().frame(height: 80)
        }
        .background(Color.background.ignoresSafeArea())
    }

    // MARK: - card section

    private var cardSection: some View {
        VStack(spacing: 10) {
            
            Spacer().frame(height: 20)
            
            VStack {
                Text("정말 최고야!")
                    .font(.NotoSans_30_B)
                    .foregroundStyle(Color.main)
                
                Text("벌써 이야기 하나를 완벽하게 끝냈어!")
                    .font(.NotoSans_16_R)
                    .foregroundStyle(Color.textGray)
            }.padding(.horizontal, 20)
            
            // TODO: 표지 이미지 넣기, 크기 조정 가능하도록 컴포넌트 변경
            StoryBookView(
                type: .finished(
                    title: nil,
                    cover: nil,
                    purpleBackground: true
                )
            )
            
            Capsule()
                .fill(Color.tGray)
                .frame(width: 50, height: 6)
            
            AcornRewards(count: 3)
            
            Spacer().frame(height: 20)
        }
        .frame(width: 353)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color.white)
        )
    }
}

#Preview {
    QuizEndView()
}
