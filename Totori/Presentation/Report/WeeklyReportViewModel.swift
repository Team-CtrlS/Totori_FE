//
//  WeeklyReportViewModel.swift
//  Totori
//
//  Created by 복지희 on 3/5/26.
//

import Combine
import Foundation

// MARK: - Model

struct Child: Codable {
    let name: String
    let age: Int?
    let profileUrl: String?
}

enum DayOfWeek: String, Codable, CaseIterable {
    // TODO: 백엔드 응답값에 맞춰서 수정
    case mon = "MONDAY"
    case tue = "TUESDAY"
    case wed = "WEDNESDAY"
    case thu = "THURSDAY"
    case fri = "FRIDAY"
    case sat = "SATURDAY"
    case sun = "SUNDAY"

    var koreanShort: String {
        switch self {
        case .mon: return "월"
        case .tue: return "화"
        case .wed: return "수"
        case .thu: return "목"
        case .fri: return "금"
        case .sat: return "토"
        case .sun: return "일"
        }
    }

    var isWeekend: Bool { self == .sat || self == .sun }
}

struct BookItem: Codable, Identifiable {
    let id: Int
    let title: String
    let isCompleted: Bool
}

struct WeeklyLearningDay: Codable, Identifiable {
    var id: String { date }
    let date: String
    let dayOfWeek: DayOfWeek
    let studied: Bool
    let bookCount: Int
}

struct QuizAccuracy: Codable {
    let correctCount: Int
    let totalCount: Int
}

struct Completion: Codable {
    let completedBookCount: Int
    let totalBookCount: Int
}

struct WCPM: Codable {
    let average: Double
    let daily: [WCPMDaily]
    
    var maxWcpm: Double {
        return daily.map { $0.wcpm }.max() ?? 0.0
    }
}

struct WCPMDaily: Codable, Identifiable {
    var id: Int
    let book: String
    let wcpm: Double
}

// MARK: - ViewModel

final class WeeklyReportViewModel: ObservableObject {
    
    @Published var selectedDate: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }()
    
    @Published var child = Child (
        name: "김밤톨",
        age: 7,
        profileUrl: "https://picsum.photos/100"
    )
    @Published var weeklyLearning: [WeeklyLearningDay] = [
        .init(date: "2026-03-10", dayOfWeek: .mon, studied: true,  bookCount: 2),
        .init(date: "2026-03-11", dayOfWeek: .tue, studied: false, bookCount: 0),
        .init(date: "2026-03-12", dayOfWeek: .wed, studied: true,  bookCount: 1),
        .init(date: "2026-03-13", dayOfWeek: .thu, studied: true,  bookCount: 1),
        .init(date: "2026-03-14", dayOfWeek: .fri, studied: true,  bookCount: 4),
        .init(date: "2026-03-15", dayOfWeek: .sat, studied: false,  bookCount: 0),
        .init(date: "2026-03-16", dayOfWeek: .sun, studied: false,  bookCount: 0)
    ]
    @Published var selectedBooks: [BookItem] = [
        .init(id: 1, title: "도토리 숲의 비밀 모험", isCompleted: false),
        .init(id: 2, title: "반딧불이를 만나요", isCompleted: true),
        .init(id: 3, title: "돔돔의 영어교실", isCompleted: true)
    ]
    @Published var completion = Completion (
        completedBookCount: 3,
        totalBookCount: 6
    )
    @Published var wcpm = WCPM (
        average: 73,
        daily: [
            .init(id:1, book: "도토리 숲의 비밀 모험", wcpm: 67),
            .init(id:2, book: "반딧불이를 만나요", wcpm: 81),
            .init(id:3, book: "돔돔의 영어교실", wcpm: 70),
            .init(id:4, book: "공주님의 하루", wcpm: 60),
            .init(id:5, book: "식물과 나", wcpm: 66),
            .init(id:6, book: "비가 내려요", wcpm: 62),
            .init(id:7, book: "책읽기는 재밌어", wcpm: 79),
        ]
    )
    
    var completionProgress: Double {
        guard completion.totalBookCount > 0 else { return 0 }
        return Double(completion.completedBookCount) / Double(completion.totalBookCount)
    }
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
        
    private let reportService = ReportService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchAll() {
        fetchWeeklyReport()
    }
    
    func fetchWeeklyReport() {
        isLoading = true
            
        reportService.getWeeklyReport()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("주간 리포트 로드 실패: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.applyWeeklyReport(response)
            }
            .store(in: &cancellables)
    }
        
    private func applyWeeklyReport(_ dto: WeeklyReportDTO) {
        self.child = Child(
            name: dto.child.name,
            age: dto.child.age,
            profileUrl: self.child.profileUrl
        )
            
        // 주간 학습 현황
        self.weeklyLearning = dto.weeklyLearning.map {
            WeeklyLearningDay(
                date: $0.date,
                dayOfWeek: DayOfWeek(rawValue: $0.dayOfWeek) ?? .mon,
                studied: $0.studied,
                bookCount: $0.bookCount
            )
        }
            
        // 도서 완독률
        self.completion = Completion(
            completedBookCount: dto.completion.completedBookCount,
            totalBookCount: dto.completion.totalBookCount
        )
            
        // wcpm 그래프
        let dailyWcpm = dto.wcpm.daily.enumerated().map { (index, point) in
            WCPMDaily(
                id: index,
                book: point.label, // 우선 날짜를 이름 대용으로 사용
                wcpm: Double(point.value)
            )
        }
            
        self.wcpm = WCPM(
            average: Double(dto.wcpm.average),
            daily: dailyWcpm
        )
    }
}
