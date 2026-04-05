//
//  SignUpRequestDTO.swift
//  Totori
//
//  Created by 정윤아 on 4/5/26.
//

import Foundation

struct SignUpRequestDTO: Codable {
    let loginId: String
    let password: String
    let name: String
    let role: String // CHILD / PARENT
}
