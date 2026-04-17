//
//  NavigationState.swift
//  Totori
//
//  Created by 정윤아 on 4/17/26.
//

import Combine
import SwiftUI

final class NavigationState: ObservableObject {
    @Published var rootId = UUID()
    
    func popToRoot() {
        rootId = UUID()
    }
}
