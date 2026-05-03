//
//  MainStatusResponseDTO.swift
//  Totori
//
//  Created by 정윤아 on 4/12/26.
//

import Foundation

struct MainStatusResponseDTO: Decodable {
    let acorn: AcornDTO?
    let currentBook: CurrentBookDTO?
    let badge: BadgeDTO?
}

struct CurrentBookDTO: Decodable {
    let bookId: Int
    let title: String
    let coverImageUrl: String?
    let acornCount: Int
    let currentPage: Int
    let totalPage: Int
    let progressPercentage: Double
}

struct AcornDTO: Decodable {
    let name: String
    let acorn: Int
}

struct BadgeDTO: Decodable {
    let id: Int
    let category: String
    let categoryName: String
    let name: String
    let level: Int
    let targetValue: Int
    let imageUrl: String?
}
