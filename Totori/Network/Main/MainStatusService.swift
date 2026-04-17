//
//  MainStatusService.swift
//  Totori
//
//  Created by 정윤아 on 4/12/26.
//

import Combine
import Foundation

final class MainStatusService {
    private let networkService = BaseService<TotoriAPI>()
    
    func fetchMainStatus() -> AnyPublisher<MainStatusResponseDTO, NetworkError> {
        return networkService.request(.mainStatus, responseType: MainStatusResponseDTO.self)
    }
    
    func fetchBookList(page: Int, size: Int) -> AnyPublisher<BookListResponseDTO, NetworkError> {
            return networkService.request(
                .bookList(page: page, size: size),
                responseType: BookListResponseDTO.self
            )
        }
}
