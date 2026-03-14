//
//  TotalReportViewModel.swift
//  Totori
//
//  Created by 복지희 on 3/12/26.
//

import Combine
import Foundation

// MARK: - Model

struct WCPMTotal: Codable {
    let average: Double
    let childAverage: Double
    let total: [WCPMMonth]
    
    var maxWcpm: Double {
        let maxInArray = total.map { $0.wcpm }.max() ?? 0.0
        return max(maxInArray, childAverage)
    }
}

struct WCPMMonth: Codable, Identifiable {
    var id: Int
    let month: String
    let wcpm: Double
    
    var displayMonth: String {
        let parts = month.split(separator: "-")
        if parts.count == 2, let monthInt = Int(parts[1]) {
            return "\(monthInt)월"
        }
        return month
    }
}

struct wrongAnalysis: Codable {
    let label: String
    let wrongCount: Int
    let totalCount: Int
    
    var progress: Double {
        guard totalCount > 0 else { return 0.0 }
        return (Double(wrongCount) / Double(totalCount))
    }
}

// MARK: - ViewModel

final class TotalReportViewModel: ObservableObject {
    
    @Published var child = Child (
        name: "김밤톨",
        age: 7,
        profileUrl: "https://picsum.photos/100"
    )

    @Published var wcpm = WCPMTotal (
        average: 73,
        childAverage: 89,
        total: [
            .init(id:1, month: "2026-03", wcpm: 67),
            .init(id:2, month: "2026-02", wcpm: 81),
            .init(id:3, month: "2026-01", wcpm: 70),
            .init(id:4, month: "2025-12", wcpm: 60),
            .init(id:5, month: "2025-11", wcpm: 66),
            .init(id:6, month: "2025-10", wcpm: 62)
        ]
    )
    
    @Published var wrong: [wrongAnalysis] = [
        .init(label: "ㄱ 받침 발음", wrongCount: 28, totalCount: 60),
        .init(label: "유사 발음 혼동", wrongCount: 20, totalCount: 60),
        .init(label: "조사 생략", wrongCount: 10, totalCount: 60),
        .init(label: "ㅇ 받침 탈락", wrongCount: 2, totalCount: 60)
    ]
    
    func getChartStyle(progress: Double) -> ProgressBarStyle {
        switch progress {
        case 0.0..<0.2:
            return .chart0
        case 0.2..<0.4:
            return .chart20
        case 0.4..<0.6:
            return .chart40
        case 0.6..<0.8:
            return .chart60
        default:
            return .chart80
        }
    }
}
