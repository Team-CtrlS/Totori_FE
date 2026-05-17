//
//  ConnectDTO.swift
//  Totori
//
//  Created by 복지희 on 5/15/26.
//

import Foundation

struct ConnectCodeResponseDTO: Decodable {
    let code: String
    let validTime: Int
}
