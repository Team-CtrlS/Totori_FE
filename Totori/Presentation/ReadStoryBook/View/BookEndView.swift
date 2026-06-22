//
//  BookEndView.swift
//  Totori
//
//  Created by 복지희 on 2/26/26.
//

import SwiftUI
import Kingfisher

struct BookEndView: View {
    @EnvironmentObject var navState: NavigationState
    
    let completeResult: BookCompleteResponseDTO?
    let coverImageUrl: String
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            Image(.profileSmile)
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 170)
            
            cardSection
            
            CTAButton(title: "홈으로", type: .purple) {
                print("🔄 홈으로 이동 (스택 초기화)")
                navState.popToRoot()
            }
            
            Spacer().frame(height: 80)
        }
        .padding(.horizontal, 20)
        .background(Color.main20.ignoresSafeArea())
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
            
            // 표지 이미지
            if !coverImageUrl.isEmpty, let url = URL(string: coverImageUrl) {
                KFImage(url)
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 40)
            } else {
                StoryBookView(
                    type: .finished(
                        title: nil,
                        cover: nil,
                        purpleBackground: true
                    )
                )
            }
            
            Capsule()
                .fill(Color.tGray)
                .frame(width: 50, height: 6)
            
            AcornRewards(count: completeResult?.totalReceivedAcorn ?? 0)
            
            Spacer().frame(height: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color.white)
        )
    }
}
