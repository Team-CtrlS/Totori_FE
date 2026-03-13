//
//  InfoViewModel.swift
//  Totori
//
//  Created by 정윤아 on 3/12/26.
//

import Combine
import SwiftUI

class InfoViewModel: ObservableObject {
    @Published var name: String = "김밤톨"
    @Published var birthDate: String = "20180101"
    @Published var gender: String = "여"
    @Published var phoneNumber: String = "01000000000"
    
    let totalBooks: String = "000권"
    let acorns: String = "23개"
    
    func saveChanges() {
        print("서버에 데이터 저장: \(birthDate), \(phoneNumber)")
        // TODO: API 호출 로직 추가
    }
}
