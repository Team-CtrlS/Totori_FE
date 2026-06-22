//
//  BookService.swift
//  Totori
//
//  Created by 정윤아 on 4/6/26.
//

import Combine
import Foundation

class BookService {
    private let networkService = BaseService<TotoriAPI>(timeoutInterval: 300)
    
    func generateBook(param: BookGenerateRequestDTO) -> AnyPublisher<BookGenerateResponseDTO, NetworkError> {
        return networkService.request(.generateBook(param: param), responseType: BookGenerateResponseDTO.self)
    }
    
    func makeBook(audioURL: URL) -> AnyPublisher<BookGenerateResponseDTO, NetworkError> {
        return networkService.request(.makeBook(audioURL: audioURL), responseType: BookGenerateResponseDTO.self)
    }
    
    func uploadReadingAudio(bookId: Int, sentenceNum: Int, audioURL: URL) -> AnyPublisher<EmptyData, NetworkError> {
        return networkService.request(
            .uploadReadingAudio(bookId: bookId, sentenceNum: sentenceNum, audioURL: audioURL),
            responseType: EmptyData.self
        )
    }
    
    func completeBook(bookId: Int, acornCount: Int) -> AnyPublisher<BookCompleteResponseDTO, NetworkError> {
        return networkService.request(
            .completeBook(bookId: bookId, acornCount: acornCount),
            responseType: BookCompleteResponseDTO.self
        )
    }
}
