//
//  LoginView.swift
//  Totori
//
//  Created by 정윤아 on 2/24/26.
//

import SwiftUI

struct LoginView: View {
    let role: SignUpType
    
    @State private var navigateToSignUp: Bool = false
    
    @State private var idInput: String = ""
    @State private var passwordInput: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading) {
                Image(.logoFlatPurple)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 83, height: 20)
                
                Text("소리를 놀이로, 읽기를 재미로")
                    .font(.NotoSans_24_SB)
                    .foregroundColor(.tBlack)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 90)
            
            VStack(alignment: .leading, spacing: 4) {
                TextField("아이디를 입력하세요.", text: $idInput)
                    .font(.NotoSans_16_R)
                    .foregroundColor(.tBlack)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color(.tLightGray))
                    .clipShape(
                        .rect(
                            topLeadingRadius: 14,
                            topTrailingRadius: 14
                        )
                    )
                
                TextField("비밀번호를 입력하세요.", text: $passwordInput)
                    .font(.NotoSans_16_R)
                    .foregroundColor(.tBlack)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color(.tLightGray))
                    .clipShape(
                        .rect(
                            bottomLeadingRadius: 14,
                            bottomTrailingRadius: 14
                        )
                    )
                    .padding(.bottom, 16)
                
                CTAButton(
                    title: "로그인",
                    type: .purple,
                    width: 353,
                    action: {
                        print("로그인")
                    })
            }
            .padding(.bottom, 20)
            
            HStack {
                Button(action: {
                    navigateToSignUp = true
                }) {
                    Text("회원가입")
                        .font(.NotoSans_14_R)
                        .foregroundColor(.textGray)
                        .underline()
                }
                
                Spacer()
                
                Button(action: {
                    print("id, 비밀번호 찾기 클릭")
                }) {
                    Text("ID/비밀번호 찾기")
                        .font(.NotoSans_14_R)
                        .foregroundColor(.textGray)
                        .underline()
                }
            }
            .padding(.bottom, 90)
            
            Divider().padding(.bottom, 20)
            
            VStack(alignment: .center, spacing: 10) {
                Text("또는")
                    .font(.NotoSans_14_R)
                    .foregroundColor(.textGray)
                
                HStack(spacing: 10) {
                    Button(action: {
                        print("카카오 로그인")
                    }) {
                        Image(.icKakao)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 39, height: 38)
                    }
                    
                    Button(action: {
                        print("구글 로그인")
                    }) {
                        Image(.icGoogle)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 39, height: 38)
                    }
                    
                    Button(action: {
                        print("네이버 로그인")
                    }) {
                        Image(.icNaver)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 39, height: 38)
                    }
                    
                    Button(action: {
                        print("애플 로그인")
                    }) {
                        Image(.icApple)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 39, height: 38)
                    }
                }
                .padding(.bottom, 204)
            }
        }
        .padding(.horizontal, 20)
        .navigationDestination(isPresented: $navigateToSignUp) {
            SignUpView(viewModel: SignUpViewModel(role: role))
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LoginView(role: .child)
}
