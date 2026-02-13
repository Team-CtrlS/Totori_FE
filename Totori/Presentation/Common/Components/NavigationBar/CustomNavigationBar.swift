//
//  CustomNavigationBar.swift
//  Totori
//
//  Created by 정윤아 on 2/13/26.
//

import SwiftUI

enum NavigationBarType {
    case text(String)
    case textLogo
    case logo
}

struct CustomNavigationBar<RightContent: View>: View {
    
    // MARK: - Properties
    
    let centerType: NavigationBarType
    let leftAction: (() -> Void)?
    let rightContent: RightContent
    
    // MARK: - Inits
    
    //화살표가 있는 경우
    init (
        centerType: NavigationBarType,
        leftAction: (() -> Void)? = nil,
        @ViewBuilder rightContent: () -> RightContent
    ) {
        self.centerType = centerType
        self.leftAction = leftAction
        self.rightContent = rightContent()
    }
    
    //화살표가 없는 경우
    init(
        centerType: NavigationBarType,
        leftAction: (() -> Void)? = nil,
    ) where RightContent == EmptyView {
        self.centerType = centerType
        self.leftAction = leftAction
        self.rightContent = EmptyView()
    }
    
    var body: some View {
        HStack {
            if let action = leftAction {
                Button(action: action) {
                    Image(.leftPurple)
                        .padding(20)
                }
            } else {
                Spacer().frame(width: 44)
            }
            
            Spacer()
            
            rightContent
                .padding(.trailing, 20)
        }
        .frame(height: 66)
        .overlay( centerView )
        .background(Color.white)
    }
    
    @ViewBuilder
    private var centerView: some View {
        switch centerType {
        case .text(let title):
            Text(title)
                .font(.NotoSans_16_SB)
                .foregroundColor(.tBlack)
            
        case .textLogo:
            Image(.logoFlatPurple)
                .resizable()
                .scaledToFit()
                .frame(height: 11)
            
        case .logo:
            Image(.icLogoPurple)
                .resizable()
                .scaledToFit()
                .frame(height: 30)
        }
    }
}
