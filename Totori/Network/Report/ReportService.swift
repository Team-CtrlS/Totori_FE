//
//  ReportService.swift
//  Totori
//
//  Created by 복지희 on 5/8/26.
//

import Combine
import Foundation

import CombineMoya
import Moya

class ReportService {
    private let networkService = BaseService<TotoriAPI>()
    
    func getWeeklyReport() -> AnyPublisher<WeeklyReportDTO, NetworkError> {
        return networkService.request(.weeklyReport, responseType: WeeklyReportDTO.self)
    }
}
