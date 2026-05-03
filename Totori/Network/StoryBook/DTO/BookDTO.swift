//
//  BookDTO.swift
//  Totori
//
//  Created by 정윤아 on 4/6/26.
//

import Foundation

struct BookGenerateRequestDTO: Encodable {
    let sttText: String
}

struct BookGenerateResponseDTO: Decodable {
    let bookId: Int
    let title: String
    let totalPages: Int
    let coverImagePrompt: String?
    let coverImageUrl: String
    let pages: [BookPageResponseDTO]
}

struct BookPageResponseDTO: Decodable {
    let pageId: Int
    let pageOrder: Int
    let sentences: [String]
    let imageUrl: String
}
