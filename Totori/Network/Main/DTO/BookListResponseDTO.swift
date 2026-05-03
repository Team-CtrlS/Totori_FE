//
//  BookListResponseDTO.swift
//  Totori
//
//  Created by 정윤아 on 4/12/26.
//

import Foundation

struct BookListResponseDTO: Decodable {
    let books: [BookSummaryDTO]
    let totalPages: Int
    let totalElements: Int
    let isLast: Bool
}

struct BookSummaryDTO: Decodable {
    let bookId: Int
    let title: String
    let coverImageUrl: String?
    let progress: Double
    let hasBadge: Bool
}
