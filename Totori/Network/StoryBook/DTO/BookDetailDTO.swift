//
//  BookDetailDTO.swift
//  Totori
//
//  Created by 정윤아 on 5/15/26.
//

struct BookDetailResponseDTO: Decodable {
    let cover: BookCoverDTO
    let pages: [BookPageDTO]
}

struct BookCoverDTO: Decodable {
    let bookId: Int
    let title: String
    let coverImageUrl: String
    let acornCount: Int
    let currentPage: Int
    let totalPage: Int
    let progress: Double
}

struct BookPageDTO: Decodable {
    let pageId: Int
    let pageOrder: Int
    let sentences: [BookSentenceDTO]
    let imageUrl: String
}

struct BookSentenceDTO: Decodable {
    let text: String
    let audioUrl: String?
    let durationMs: Int?
}
