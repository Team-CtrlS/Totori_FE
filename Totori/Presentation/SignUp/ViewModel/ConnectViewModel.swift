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
    
    var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%d분 %02d초", minutes, seconds)
    }
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var timer: Timer?
    private let connectService = SignUpService()
    private var cancellables = Set<AnyCancellable>()
    

    
    init(role: SignUpType) {
        self.role = role
        
        if role == .child {
            fetchNewPinCode()
        }
    }
    
    func fetchNewPinCode() {
        timer?.invalidate()
        timer = nil
        
        isLoading = true
        errorMessage = nil
            
        connectService.getConnectCode()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("코드 발급 실패: \(error.localizedDescription)")
                    self?.errorMessage = "코드를 불러올 수 없습니다."
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                    
                self.pinCode = response.code
                self.timeRemaining = response.validTime
                    
                self.startTimer()
            }
            .store(in: &cancellables)
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
