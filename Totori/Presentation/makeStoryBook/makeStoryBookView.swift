//
//  makeStoryBookView.swift
//  Totori
//
//  Created by 정윤아 on 2/27/26.
//

import SwiftUI

struct makeStoryBookView: View {
    @StateObject private var viewModel = makeStoryBookViewModel()
    
    var body: some View {
        VStack {
            HStack {
                ChipView(type: .profile(name: viewModel.userName, imageURL: viewModel.userImage))
                
                Spacer()
                
                HStack(spacing: 10) {
                    ChipView(type: .trophy)
                    ChipView(type: .acorn(amount: viewModel.acornCount))
                    ChipView(type: .question)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 32)
            
            chatView
            
            if viewModel.currentStep == .processing {
                processingView
                    .padding(.top, 46)
                    .padding(.bottom, 46)
            } else {
                listeningView
                    .padding(.top, 20)
                    .padding(.bottom, 77)
            }
            
            if viewModel.currentStep == .processing {
                AutoScrollView()
                    .padding(.bottom, 40)
            } else {
                BottomControl(
                    type: viewModel.currentCenterType,
                    onCenterTap: {
                        viewModel.performCenterAction()
                    },
                    onPrevTap: {
                        viewModel.goPrevStep()
                    }
                )
                .padding(.bottom, 40)
            }
            
            Spacer()
        }
        .background(.main20)
    }
    
    private var chatView: some View {
        HStack(spacing: 20) {
            viewModel.currentStep.chatIcon
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
            
            Text(viewModel.currentStep.chatMessage(userName: viewModel.userName))
                .font(.NotoSans_20_R)
                .foregroundColor(.tBlack)
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }
    
    private var listeningView: some View {
        //TODO: - GIF Image로 바꾸기
        Rectangle()
            .frame(width: 260, height: 260)
            .foregroundColor(.gray)
    }
    
    private var processingView: some View {
        //TODO: - GIF 이미지로 바꾸기
        VStack(spacing: 46) {
            Rectangle()
                .frame(width: 200, height: 302)
                .foregroundColor(.gray)
            
            Text("동화 속 세상을 만드는 중...")
                .font(.NotoSans_20_SB)
                .foregroundColor(.main)
        }
    }
}

struct AutoScrollView: View {
    @State private var offset: CGFloat = 0
    let itemWidth: CGFloat = 310
    let spacing: CGFloat = 10
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: spacing) {
                ForEach(0..<6, id: \.self) { index in
                    tipBox(index: index % 3)
                    
                }
            }
            .offset(x: offset)
            .onAppear {
                let moveDistance = (itemWidth + spacing) * 3
                withAnimation(.linear(duration: 25.0).repeatForever(autoreverses: false)) {
                    offset = -moveDistance
                }
            }
        }
    }
    private func tipBox(index: Int) -> some View {
            let titles = [
                "새로운 이야기에 대해...",
                "나의 최애 동물은?",
                "누구와 함께 모험을 떠날까?"
            ]
            
            let descriptions = [
                "이야깃거리가 떠오르지 않는다면 아침에\n무슨 일이 있었는지 이야기해봐!",
                "좋아하는 동물로 동화를 만들어줄게\n동물 말고 캐릭터도 좋아",
                "친구나 가족, 혹은 상상 속의 친구를\n동화 속 주인공으로 초대해 봐!"
            ]
            
            let safeIndex = index % 3
            
            return HStack(spacing: 21.52) {
                Image(.arconBadge)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26.96, height: 37.88)
                
                VStack(alignment: .leading) {
                    Text(titles[safeIndex])
                        .font(.NotoSans_16_SB)
                        .foregroundColor(.tBlack)
                    
                    Text(descriptions[safeIndex])
                        .font(.NotoSans_14_R)
                        .foregroundColor(.textGray)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(10)
            .frame(width: itemWidth, height: 82)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
}

#Preview {
    makeStoryBookView()
}
