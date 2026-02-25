//
//  AcornRewards.swift
//  Totori
//
//  Created by 복지희 on 2/25/26.
//

import SwiftUI

struct AcornRewards: View {

    let count: Int
    let maxCount: Int = 3

    var body: some View {
        let safeCount = min(max(count, 0), maxCount)

        HStack(spacing: 10) {
            ForEach(0..<maxCount, id: \.self) { index in
                Image(index < safeCount ? .acornActive : .acornInactive)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
        }
    }
}
