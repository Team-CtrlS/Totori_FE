//
//  ReportCommonDTO.swift
//  Totori
//
//  Created by 복지희 on 5/8/26.
//

import Foundation

struct ChildDTO: Decodable {
    let name: String
    let age: Int?
}

struct DataPointDTO: Decodable {
    let label: String
    let value: Double
}
