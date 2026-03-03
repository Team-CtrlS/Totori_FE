//
//  ReadStoryBookView.swift
//  Totori
//
//  Created by 정윤아 on 2/28/26.
//

import SwiftUI

struct ReadStoryBookView: View {
    @StateObject private var viewModel = ReadStoryBookViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $viewModel.currentIndex) {
                ForEach(viewModel.displayPages.indices, id: \.self) { index in
                    GeometryReader { proxy in
                        let pageDate = viewModel.displayPages[index]
                        
                        AsyncImage(url: URL(string: pageDate.imageUrl)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                            } else if phase.error != nil {
                                Color.gray.opacity(0.5)
                            } else {
                                Color.white
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .clipped()
                        .ignoresSafeArea()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onTapGesture {
                viewModel.togglePanel()
            }
            
            bottomSheetView
                .offset(y: viewModel.isPanelVisible ? 0 : 305)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.isPanelVisible)
        }
    }
    
    private var bottomSheetView: some View {
        VStack {
            Capsule()
                .fill(.tGray)
                .frame(width: 50, height: 6)
                .padding(.horizontal, 171.5)
                .padding(.vertical, 20)
                .onTapGesture {
                    viewModel.togglePanel()
                }
            
            ProgressBar(progress: viewModel.progressRatio)
                .padding(.horizontal, 20)
            
            Text("\(viewModel.currentDisplayPage.text)")
                .font(.NotoSans_24_R)
                .foregroundColor(.tBlack)
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    Rectangle()
                        .fill(viewModel.isTTSSpeaking ? Color.main20 : Color.clear)
                        .padding(20)
                )
                .onTapGesture {
                    viewModel.toggleTTS()
                }
            
            BookBottomControls(
                centerType: viewModel.centerControlType,
                isPrevEnabled: viewModel.isPrevEnabled,
                isNextEnabled: viewModel.isNextEnabled,
                onTapPrev: { viewModel.goPrev() },
                onTapNext: { viewModel.goNext() },
                onTapCenter: { viewModel.toggleMic() }
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(
            Color.white
                .clipShape(
                    .rect(
                        topLeadingRadius: 30,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 30
                    )
                )
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

#Preview{
    ReadStoryBookView()
}
