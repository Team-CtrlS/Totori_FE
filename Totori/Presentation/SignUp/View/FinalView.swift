//
//  FinalView.swift
//  Totori
//
//  Created by 정윤아 on 2/26/26.
//

import SwiftUI

struct FinalView: View {
    var body: some View {
        ZStack(){
            VStack(alignment: .leading) {
                VStack(alignment: .leading){
                    Image(.logoFlatPurple)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 83, height: 20)
                        .padding(.bottom, 20)
                    
                    Text("토토리에 오신 것을 환영합니다")
                        .font(.NotoSans_24_SB)
                        .foregroundColor(.tBlack)
                    
                    Text("앞으로 함께할 나날이 정말 기대돼요!")
                        .font(.NotoSans_14_R)
                        .foregroundColor(.textGray)
                }
                
                Spacer()
                
                CTAButton(
                    title: "시작하기",
                    type: .purple,
                    width: 353,
                    action: {
                        //TODO: 메인화면 연결하기
                        print("메인화면으로 이동")
                    }
                )
                .padding(.bottom, 34)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            Image(.icLogoPurple)
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 170)
            
            Spacer()
        }
    }
}

#Preview {
    FinalView()
}
