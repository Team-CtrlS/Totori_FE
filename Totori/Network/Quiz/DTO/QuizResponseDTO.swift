//
//  QuizResponseDTO.swift
//  Totori
//
//  Created by 정윤아 on 5/15/26.
//

import Foundation
 
struct QuizResponseDTO: Decodable {
    let quizId: Int
    let quizItems: [String]
    let audioUrls: [String]
}

struct QuizCheckResponseDTO: Decodable {
    let isCorrect: Bool
    let rewarded: Bool
    let currentAcorn: Int
}
