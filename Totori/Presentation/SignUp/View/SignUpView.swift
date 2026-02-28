//
//  SignUpView.swift
//  Totori
//
//  Created by 정윤아 on 2/25/26.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject var viewModel: SignUpViewModel
    
    //시스템 뒤로가기 대신 커스텀 뒤로가기 사용
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomNavigationBar(centerType: .text("회원가입"))
                .padding(.bottom, 20)
                .padding(.top, 18)
            
            VStack(alignment: .leading) {
                
                Image(.logoFlatPurple)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 83, height: 20)
                    .padding(.bottom, 20)
                
                Text(mainTitle)
                    .font(.NotoSans_24_SB)
                    .foregroundColor(.tBlack)
                
                Text(subTitle)
                    .font(.NotoSans_14_R)
                    .foregroundColor(.textGray)
                    .padding(.bottom, 60)
                
                switch viewModel.currentStep {
                case 1: EmailStepView(viewModel: viewModel)
                case 2: PasswordStepView(viewModel: viewModel)
                case 3: PasswordConfirmStepView(viewModel: viewModel)
                case 4: NameStepView(viewModel: viewModel)
                default: EmptyView()
                }
                
                
                CTAButton(
                    title: viewModel.currentStep == 4 ? "가입하기" : "다음",
                    type: .purple,
                    width: 353,
                    action: {viewModel.goNextStep()}
                )
                .disabled(!viewModel.isCurrentStepValid)
                .opacity(viewModel.hasCurrentInput ? 1 : 0)
                .padding(.top, 40)
                
                Spacer()
                
            }
            .padding(.horizontal, 20)
            .navigationDestination(isPresented: $viewModel.navigateToFinalView) {
                FinalView()
            }
            .navigationDestination(isPresented: $viewModel.navigateToConnectView) {
                
                ConnectView(viewModel: ConnectViewModel(role: viewModel.role))
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private var mainTitle: String {
        switch viewModel.currentStep {
        case 1: return "먼저, 이메일을 입력해주세요"
        case 2: return "비밀번호를 설정해주세요"
        case 3: return "비밀번호를 다시 입력해주세요"
        case 4: return "다음으로 성함을 입력해주세요"
        default: return ""
        }
    }
    
    private var subTitle: String {
        switch viewModel.currentStep {
        case 1: return "토토리를 로그인할 때 사용하게 될 아이디예요."
        case 2: return "8글자 이상, 소문자 영어와 숫자가 반드시 조합되어야 해요."
        case 3: return "직전에 입력한 비밀번호를 다시 한 번 작성해주세요."
        case 4: return "성과 이름을 붙여서 입력해주세요."
        default: return ""
        }
    }
}

#Preview {
    SignUpView(viewModel: SignUpViewModel(role: .child))
}
