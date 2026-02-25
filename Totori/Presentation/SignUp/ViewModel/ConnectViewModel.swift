//
//  ConnectViewModel.swift
//  Totori
//
//  Created by 정윤아 on 2/26/26.
//

import Combine
import SwiftUI

class ConnectViewModel: ObservableObject {
    let role: SignUpType
    
    @Published var pinCode: String = "" {
        didSet {
            if role == .parent && pinCode.count > 5 {
                pinCode = String(pinCode.prefix(5))
            }
        }
    }
    
    @Published var timeRemaining: Int = 30
    private var timer: Timer?
    
    init(role: SignUpType) {
        self.role = role
        
        if role == .child {
            fetchNewPinCode()
        }
    }
    
    func fetchNewPinCode() {
        // 지금은 임시로 랜덤 5자리 숫자를 생성
        let randomPin = String(format: "%05d", Int.random(in: 0...99999))
        self.pinCode = randomPin
        
        self.timeRemaining = 30
        startTimer()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.fetchNewPinCode()
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
