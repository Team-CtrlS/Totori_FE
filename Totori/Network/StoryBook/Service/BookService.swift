//
//  BookService.swift
//  Totori
//
//  Created by 정윤아 on 4/6/26.
//

import Combine
import Foundation

class BookService {
    private let networkService = BaseService<TotoriAPI>()
    
    func generateBook(param: BookGenerateRequestDTO) -> AnyPublisher<BookGenerateResponseDTO, NetworkError> {
        return networkService.request(.generateBook(param: param), responseType: BookGenerateResponseDTO.self)
    }
}
