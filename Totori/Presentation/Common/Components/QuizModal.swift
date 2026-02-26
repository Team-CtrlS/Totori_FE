//
//  QuizModal.swift
//  Totori
//
//  Created by 복지희 on 2/25/26.
//

import SwiftUI

// MARK: - Model

enum ResultCardType {
    case retry(userName: String)
    case perfect(userName: String)

    var title: String {
        switch self {
        case .retry:   return "다시 시도해볼까?"
        case .perfect: return "완벽해!"
        }
    }

    var titleColor: Color {
        switch self {
        case .retry: return .main
        case .perfect: return .point
        }
    }

    var message: String {
        switch self {
        case .retry(let userName):
            return """
            더 좋은 결과를 얻을 수 있을거야!
            힘내서 다시 해보자, \(userName)!
            """
        case .perfect(let userName):
            return """
            벌써 훌륭하게 해내다니, 역시 \(userName)!
            앞으로의 활약도 계속 응원할게!
            """
        }
    }

    // TODO: 실패 시 캐릭터 이미지 수정
    var characterImage: Image {
        switch self {
        case .retry:
            return Image(.profileSmile)
        case .perfect:
            return Image(.profileSmile)
        }
    }
}

// MARK: - View

struct QuizModal: View {

    let type: ResultCardType

    var body: some View {
        ZStack(alignment: .top) {
        
            // Card
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white)
                .frame(height: 206)
                .padding(.top, 85)

            VStack(spacing: 5) {
                Spacer().frame(height: 85 + 85)

                Text(type.title)
                    .font(.NotoSans_30_B)
                    .foregroundStyle(type.titleColor)

                Text(type.message)
                    .font(.NotoSans_16_R)
                    .foregroundStyle(.tBlack)
                    .multilineTextAlignment(.center)
            }
            
            // Character
            type.characterImage
                .frame(width: 170)

        }
        .frame(width: 353, height: 291)
    }
}
