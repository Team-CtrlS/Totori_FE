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
    let pages: [PageDTO]
}

struct PageDTO: Codable {
    let pageId: Int
    let pageOrder: Int
    let imagePrompt: String
    let imageUrl: String
    let sentences: [SentenceDTO]
}

struct SentenceDTO: Codable {
    let text: String
    let audioUrl: String?
    let durationMs: Int?
}
