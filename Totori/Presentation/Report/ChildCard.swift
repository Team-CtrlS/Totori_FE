//
//  ChildCard.swift
//  Totori
//
//  Created by 복지희 on 3/9/26.
//

import SwiftUI

struct ChildCard: View {
    
    let imageUrl: String?
    let childName: String
    let childAge: Int
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 26)
                .fill(.white)
            
            HStack(spacing: 15) {
                if let imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Circle()
                            .fill(.tGray)
                    }
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                } else {
                    Circle()
                        .fill(.tLightGray)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text(childName)
                        .font(.NotoSans_24_SB)
                        .foregroundStyle(.black)

                    Text("\(childAge)세 아동")
                        .font(.NotoSans_16_R)
                        .foregroundStyle(.textGray)
                }

                Spacer()

                Image(.more)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
                
            }
            .padding(20)
        }
    }
}
