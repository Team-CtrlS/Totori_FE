//
//  StartView.swift
//  Totori
//
//  Created by 정윤아 on 2/24/26.
//

import SwiftUI

struct StartView: View {
    
    var body: some View {
        
        ZStack {
            Color.main
                .ignoresSafeArea()
            
            VStack {
                Image(.logoFlatWhite)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 84, height: 20)
                    .padding(.top, 82)
                
                Spacer()
                
                Image(.icLogoWhite)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Image(.logoWhite)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 146, height: 44)
                
                Spacer()
                
                CTAButton(
                    title: "시작하기",
                    type: .backgroundColor,
                    width: 353,
                    action: {
                        print("시작하기")
                    }
                )
                .padding(.bottom, 80)
            }
        }
    }
}

#Preview {
    StartView()
}
