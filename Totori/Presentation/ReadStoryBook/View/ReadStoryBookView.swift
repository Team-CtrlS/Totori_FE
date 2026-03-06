//
//  ReadStoryBookView.swift
//  Totori
//
//  Created by 정윤아 on 2/28/26.
//

import SwiftUI

struct ReadStoryBookView: View {
    @StateObject private var viewModel = ReadStoryBookViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var showModal: Bool = false
    @State private var navigateToStart: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    showModal = true
                }){
                    Image(.close)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(.top, 80)
                        .padding(.leading, 322)
                }
                
                Spacer()
            }
            .zIndex(2)
            
            VStack(spacing: 0) {
                AsyncImage(url: URL(string: viewModel.currentDisplayPage.imageUrl)) { phase in
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                
                bottomSheetView
            }
            
            if showModal {
                QuestionModal(
                    type: .exitReading,
                    onCancel: { showModal = false },
                    onConfirm: {
                        showModal = false
                        navigateToStart = true
                    }
                )
            }
        }
        .navigationDestination(isPresented: $navigateToStart) {
            MainView()
                .navigationBarBackButtonHidden(true)
        }
    }
    
    private var bottomSheetView: some View {
        VStack {
            ProgressBar(progress: viewModel.progressRatio)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
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
            
            Spacer()
        }
        .frame(height: 330)
        .background(Color.white)
        .clipShape(
            .rect(
                topLeadingRadius: 30,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 30
            )
        )
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview{
    ReadStoryBookView()
}
