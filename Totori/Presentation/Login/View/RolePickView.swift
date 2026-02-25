import SwiftUI

struct RolePickView: View {
    @State private var isShowingModal: Bool = false
    @State private var selectedRole: SignUpType? = nil
    @State private var navigateToLogin: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading) {
                    Image(.logoFlatPurple)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 83, height: 20)
                    
                    Text("토토리 가입을 시작할게요")
                        .font(.NotoSans_24_SB)
                        .foregroundColor(.tBlack)
                    
                    Text("시작하기에 앞서, 누가 이 계정을 사용할 예정인가요?")
                        .font(.NotoSans_14_R)
                        .foregroundColor(.textGray)
                }
                .padding(.bottom, 104)
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(.icLogoPurple)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 170, height: 170)
                    .padding(.bottom, 104)
                
                Button(action: {
                    selectedRole = .child
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isShowingModal = true
                    }
                }) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("아동")
                            .font(.NotoSans_30_B)
                            .foregroundColor(.tBlack)
                        
                        Text("이야기를 만들고 읽을 수 있어요")
                            .font(.NotoSans_14_R)
                            .foregroundColor(.tBlack)
                    }
                }
                .frame(width: 333, height: 100, alignment: .leading)
                .padding(.horizontal, 10)
                .background(.main20)
                .cornerRadius(14)
                .padding(.bottom, 10)
                
                Button(action: {
                    selectedRole = .parent
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isShowingModal = true
                    }
                }) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("보호자")
                            .font(.NotoSans_30_B)
                            .foregroundColor(.tBlack)
                        
                        Text("아동의 읽기 실태를 파악하고 관리할 수 있어요")
                            .font(.NotoSans_14_R)
                            .foregroundColor(.tBlack)
                    }
                }
                .frame(width: 333, height: 100, alignment: .leading)
                .padding(.horizontal, 10)
                .background(.point50)
                .cornerRadius(14)
            }
            
            if isShowingModal, let role = selectedRole {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowingModal = false
                        }
                    }
                
                SignUpModal(
                    type: role,
                    onCancel: {
                        withAnimation {
                            isShowingModal = false
                        }
                    },
                    onContinew: {
                        isShowingModal = false
                        navigateToLogin = true
                    }
                )
            }
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
