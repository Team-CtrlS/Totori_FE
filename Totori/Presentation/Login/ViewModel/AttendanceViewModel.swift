//
//  AttendanceViewModel.swift
//  Totori
//
//  Created by 정윤아 on 4/18/26.
//

import Combine
import Foundation

final class AttendanceViewModel: ObservableObject {
    @Published var totalAttendanceDays: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    func checkAttendance() {
        AttendanceService.shared.checkAttendance()
            .receive(on: DispatchQueue.main) // UI 업데이트를 위해 메인 스레드에서 수신
            .sink { completion in
                if case .failure(let error) = completion {
                    print("❌ 메인화면 출석 체크 실패: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                self?.totalAttendanceDays = response.totalAttendanceDays
            }
            .store(in: &cancellables)
    }
}
