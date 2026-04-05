//
//  LoginRequestDTO.swift
//  Totori
//
//  Created by 정윤아 on 4/5/26.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let loginId: String
    let password: String
}
