//
//  Style+.swift
//  Totori
//
//  Created by 정윤아 on 2/10/26.
//

import SwiftUI

extension View {
    func textStyle(_ font: Font, size: CGFloat) -> some View {
        self
            .font(font)
            .lineSpacing(size * 0.4)
    }
}
