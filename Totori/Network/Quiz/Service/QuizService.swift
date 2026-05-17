//
//  QuizService.swift
//  Totori
//
//  Created by 정윤아 on 5/15/26.
//

import Combine
import Foundation
 
final class QuizService {
    private let networkService = BaseService<TotoriAPI>()
 
    func makeQuiz(bookId: Int) -> AnyPublisher<QuizResponseDTO, NetworkError> {
        return networkService.request(
            .makeQuiz(bookId: bookId),
            responseType: QuizResponseDTO.self
        )
    }
    
    func checkQuiz(quizId: Int, audioURL: URL, originalQuiz: String) -> AnyPublisher<QuizCheckResponseDTO, NetworkError> {
        return networkService.request(
            .checkQuiz(quizId: quizId, audioURL: audioURL, originalQuiz: originalQuiz),
            responseType: QuizCheckResponseDTO.self
        )
    }
}
