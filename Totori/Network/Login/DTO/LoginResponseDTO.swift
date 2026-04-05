//
//  LoginResponseDTO.swift
//  Totori
//
//  Created by 정윤아 on 4/5/26.
//

import Foundation

struct LoginResponseDTO: Decodable {
    let token: String
    let role: String
}
