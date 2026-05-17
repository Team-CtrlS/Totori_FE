//
//  SignUpResponseDTO.swift
//  Totori
//
//  Created by user on 5/17/26.
//

import Foundation

struct SignUpResponseDTO: Decodable {
    let code: String
    let validTime: Int
}
