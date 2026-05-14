//
//  BookDetailService.swift
//  Totori
//
//  Created by 정윤아 on 5/15/26.
//

import Combine
import Foundation

class BookDetailService {
    private let networkService = BaseService<TotoriAPI>()
    
    func fetchBookDetail(bookId: Int) -> AnyPublisher<BookDetailResponseDTO, NetworkError> {
        print("🌐 BookDetailService - API 요청 시작: bookId=\(bookId)")
        return networkService.request(.bookDetail(bookId: bookId), responseType: BookDetailResponseDTO.self)
            .handleEvents(
                receiveOutput: { response in
                },
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                    case .failure(let error):
                    }
                }
            )
            .eraseToAnyPublisher()
    }
}
