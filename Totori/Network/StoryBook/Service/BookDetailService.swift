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
                    print("🌐 BookDetailService - 응답 수신: \(response.cover.title)")
                },
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("🌐 BookDetailService - 완료")
                    case .failure(let error):
                        print("🌐 BookDetailService - 에러: \(error)")
                    }
                }
            )
            .eraseToAnyPublisher()
    }
}
