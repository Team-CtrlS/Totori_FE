//
//  ConnectView.swift
//  Totori
//
//  Created by 정윤아 on 2/26/26.
//

import SwiftUI

struct ConnectView: View {
    @StateObject var viewModel: ConnectViewModel
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var isPinFocused: Bool
    
    var boxColor: Color {
        viewModel.role == .child ? Color.main40 : Color.point50
    }
    
    var body: some View {
        
        CustomNavigationBar(centerType: .text("회원가입"), showsBackButton: true)
            .padding(.top, 20)
            .padding(.bottom, 20)
        
        VStack(alignment: .leading, spacing: 0) {
            
            Image(.logoFlatPurple)
                .resizable()
                .scaledToFit()
                .frame(width: 83, height: 20)
                .padding(.bottom, 8)
            
            Text(viewModel.role == .child ? "보호자와 연결하기" : "아동과 연결하기")
                .font(.NotoSans_24_SB)
                .foregroundColor(.tBlack)
            
            Text(viewModel.role == .child ? "보호자의 휴대폰에 로그인 후,\n하단에 생성된 PIN 5자를 입력해주세요." : "아동 계정의 휴대폰에 로그인 후,\n화면에 생성된 PIN 5자를 입력해주세요.")
                .font(.NotoSans_14_R)
                .foregroundColor(.textGray)
                .padding(.bottom, 100)
            
            ZStack {
                if viewModel.role == .parent {
                    TextField("", text: $viewModel.pinCode)
                        .keyboardType(.numberPad)
                        .focused($isPinFocused)
                        .opacity(0)
                }
                
                HStack(spacing: 10) {
                    ForEach(0..<5, id: \.self) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(boxColor)
                                .frame(width: 62, height: 100)
                            
                            Text(getPinCharacter(at: index))
                                .font(.NotoSans_30_B)
                                .foregroundColor(.tBlack)
                        }
                    }
                }
                .onTapGesture {
                    if viewModel.role == .parent {
                        isPinFocused = true
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 62)
            
            if viewModel.role == .child {
                VStack(spacing: 8) {
                    Text("위의 5자리 코드를 보호자의 휴대폰 화면에 입력해주세요.\n이 코드는 30초간 유효합니다.")
                        .font(.NotoSans_14_R)
                        .foregroundColor(.textGray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 14)
                    
                    HStack(spacing: 1) {
                        Text("\(viewModel.timeRemaining)초 ")
                            .font(.NotoSans_14_SB)
                            .foregroundColor(.tBlack)
                        
                        Text("후에 새로고침 됩니다.")
                            .font(.NotoSans_14_R)
                            .foregroundColor(.textGray)
                    }
                }
                .frame(maxWidth: .infinity)
                
            } else {
                Text("자녀 계정의 5자리 코드를 확인 후 빈칸에 입력해주세요.\n\n연결 코드는 자녀 회원가입 / 마이페이지 > 프로필 사진\n> 보호자와 연결 탭을 통해 받을 수 있습니다.")
                    .font(.NotoSans_14_R)
                    .foregroundColor(.textGray)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            
            Spacer()
            
            if viewModel.role == .parent {
                CTAButton(
                    title: "연결하기",
                    type: viewModel.pinCode.count == 5 ? .purple : .gray,
                    width: 353,
                    action: {
                        //TODO: 연결되었는지 확인하는 API 연결
                        print("연결 API 쏘기: \(viewModel.pinCode)")
                    }
                )
                .disabled(viewModel.pinCode.count < 5)
                .padding(.bottom, 20)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isPinFocused = false
        }
        .padding(.horizontal, 20)
        .navigationBarHidden(true)
        .onAppear {
            if viewModel.role == .parent {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isPinFocused = true
                }
            }
        }
    }
    
    private func getPinCharacter(at index: Int) -> String {
        guard index < viewModel.pinCode.count else { return "" }
        let stringIndex = viewModel.pinCode.index(viewModel.pinCode.startIndex, offsetBy: index)
        return String(viewModel.pinCode[stringIndex])
    }
}

#Preview("아동 (코드 보여주기)") {
    ConnectView(viewModel: ConnectViewModel(role: .child))
}

#Preview("부모 (코드 입력하기)") {
    ConnectView(viewModel: ConnectViewModel(role: .parent))
}
