//
//  RolePickView.swift
//  Totori
//
//  Created by 정윤아 on 4/5/26.
//

import SwiftUI

struct RolePickView: View {
    @State private var selectedRole: SignUpType? = nil
    @State private var navigateToLogin: Bool = false
    
    var titleText: String {
        switch selectedRole {
        case .child: return "아동 계정으로 시작할게요"
        case .parent: return "보호자 계정으로 시작할게요"
        case .none: return "토토리를 시작할게요"
        }
    }
    
    var characterImage: ImageResource {
        switch selectedRole {
        case .child: return .loginKid
        case .parent: return .loginAdult
        case .none: return .profileSmile
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                Image(.logoFlatPurple)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 83, height: 20)
                    .padding(.bottom, 20)
                
                Text(titleText)
                    .font(.NotoSans_24_SB)
                    .foregroundColor(.tBlack)
                
                Text("시작하기에 앞서, 누구로 시작할지 알려주세요.")
                    .font(.NotoSans_14_R)
                    .foregroundColor(.textGray)
            }
            .padding(.leading, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Image(characterImage)
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 170)
            
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedRole = .child
                }
            }) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("아동")
                        .font(.NotoSans_30_B)
                        .foregroundColor(selectedRole == .child ? .white : .tBlack)
                    
                    Text("이야기를 만들고 읽을 수 있어요")
                        .font(.NotoSans_14_R)
                        .foregroundColor(selectedRole == .child ? .white : .tBlack)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                .padding(.vertical, 19)
            }
            .background(selectedRole == .child ? .main : .main20)
            .cornerRadius(14)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedRole = .parent
                }
            }) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("보호자")
                        .font(.NotoSans_30_B)
                        .foregroundColor(selectedRole == .parent ? .white : .tBlack)
                    
                    Text("아동의 읽기 실태를 파악하고 관리할 수 있어요")
                        .font(.NotoSans_14_R)
                        .foregroundColor(selectedRole == .parent ? .white : .tBlack)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                .padding(.vertical, 19)
            }
            .background(selectedRole == .parent ? Color.point : Color.point50)
            .cornerRadius(14)
            .padding(.horizontal, 20)
            
            Spacer()
            
            CTAButton(
                title: "다음",
                type: selectedRole == nil ? .gray : .purple,
                action: {
                    if selectedRole != nil {
                        navigateToLogin = true
                    }
                }
            )
            .disabled(selectedRole == nil)
            .padding(.bottom, 44)
        }
        .navigationDestination(isPresented: $navigateToLogin) {
            if let role = selectedRole {
                LoginView(role: role)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RolePickView()
}
