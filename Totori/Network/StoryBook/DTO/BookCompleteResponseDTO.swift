//
//  BookCompleteResponseDTO.swift
//  Totori
//
//  Created by 정윤아 on 5/18/26.
//

struct BookCompleteResponseDTO: Decodable {
    let bookId: Int
    let acornCount: Int
    let totalReceivedAcorn: Int
    let newlyAcquiredBadges: [BadgeResponseDTO]
}
 
struct BadgeResponseDTO: Decodable {
    let id: Int
    let category: String        // "BOOK_READ", "ACORN" 등
    let categoryName: String
    let name: String
    let level: Int
    let targetValue: Int
    let imageUrl: String
}
