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
    let wrongAnalysis: WrongAnalysisDTO
}

struct TotalWCPMDTO: Decodable {
    let average: Double
    let childAverage: Int
    let monthly: [DataPointDTO]
}

struct WrongAnalysisDTO: Decodable {
    let items: [WrongAnalysisItemDTO]
}

struct WrongAnalysisItemDTO: Decodable {
    let label: String
    let wrongCount: Int
    let totalCount: Int
}
