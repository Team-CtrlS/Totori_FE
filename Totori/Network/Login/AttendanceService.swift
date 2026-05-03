//
//  AttendanceService.swift
//  Totori
//

import Combine
import Foundation

final class AttendanceService {
    static let shared = AttendanceService()
    private let networkService = BaseService<TotoriAPI>()
    
    private init() {}
    
    func checkAttendance() -> AnyPublisher<AttendanceResponseDTO, NetworkError> {
        return networkService.request(.attendance, responseType: AttendanceResponseDTO.self)
            .handleEvents(receiveOutput: { response in
                Logger.success(.network, "출석 체크 성공 - 새로 출석함?: \(response.newlyAttended), 총 출석일: \(response.totalAttendanceDays)")
            }, receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    Logger.error(.network, "출석 체크 실패: \(error.localizedDescription)")
                }
            })
            .eraseToAnyPublisher()
    }
}
