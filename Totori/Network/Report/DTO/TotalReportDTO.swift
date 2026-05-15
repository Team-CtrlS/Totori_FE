//
//  TotalReportDTO.swift
//  Totori
//
//  Created by 복지희 on 5/8/26.
//

import Foundation

struct TotalReportDTO: Decodable {
    let child: ChildDTO
    let wcpm: TotalWCPMDTO
    let wrongAnalysis: [WrongAnalysisItemDTO]
}

struct TotalWCPMDTO: Decodable {
    let average: Double
    let childAverage: Double
    let monthly: [DataPointDTO]
}

struct WrongAnalysisItemDTO: Decodable {
    let label: String
    let wrongCount: Int
    let totalCount: Int
}
