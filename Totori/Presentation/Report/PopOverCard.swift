//
//  PopOverCard.swift
//  Totori
//
//  Created by 복지희 on 3/13/26.
//
import SwiftUI

struct PopOverCard: View {
    let title: String
    let descript: String
    
    var body: some View {
        
        VStack(spacing: 6) {
            Image(.icLogoPurple)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            
            Text(title)
                .font(.NotoSans_14_SB)
                .foregroundColor(.black)
            
            Text(descript)
                .font(.NotoSans_12_R)
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(10)
        .frame(width: 200)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 0)
        )
    }
}
