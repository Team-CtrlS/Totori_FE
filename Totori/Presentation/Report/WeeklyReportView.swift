//
//  WeeklyReportView.swift
//  Totori
//
//  Created by 복지희 on 3/4/26.
//

import SwiftUI

struct WeeklyReportView: View {

    @StateObject private var viewModel = WeeklyReportViewModel()

    var body: some View {
        VStack(spacing: 20) {

            CustomNavigationBar(
                centerType: .text("주간레포트"),
                showsBackButton: true
            )

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    ChildCard(
                        imageUrl: viewModel.child.profileUrl,
                        childName: viewModel.child.name,
                        childAge: viewModel.child.age
                    )
                    .padding(.horizontal, 20)

                    weeklyLearningCard
                        .padding(.horizontal, 20)

                    quizAccuracyCard
                        .padding(.horizontal, 20)

                    wcpmCard
                        .padding(.horizontal, 20)
                    
                    // TODO: navigate 추가
                    CTAButton(title: "전체 리포트 보러가기", type: .purple) {
                        print("전체 페이지 이동")
                    }
                    .padding(.horizontal, 20)
                    
                    reportFooter
                }
            }
        }
        .background(Color.backgroundGray)
        .navigationBarHidden(true)
    }

    // MARK: - 주간 학습 현황
    private var weeklyLearningCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("주간 학습 현황")
                .font(.NotoSans_16_SB)
                .foregroundColor(Color.black)
            
            ZStack{
                RoundedRectangle(cornerRadius: 26)
                    .fill(Color.white)
                
                VStack(spacing: 0){
                    // 요일 + 학습 여부
                    HStack(spacing: 12) {
                        ForEach(viewModel.weeklyLearning) { day in
                            VStack(spacing: 2) {
                                Text(day.dayOfWeek.koreanShort)
                                    .font(.NotoSans_16_R)
                                    .foregroundColor(day.dayOfWeek.isWeekend ? .tRed : .textGray)
                                    .padding(.bottom, 8)

                                if day.studied {
                                    Image(.acornActive)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 26, height: 26)
                                } else{
                                    Image(.acornDeactive)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 26, height: 26)
                                }

                                // 책 권수
                                HStack(spacing: 2) {
                                    ForEach(0..<min(day.bookCount, 3), id: \.self) { _ in
                                        Circle()
                                            .fill(Color.main)
                                            .frame(width: 4, height: 4)
                                    }
                                }
                                if day.bookCount == 0 {
                                    Spacer()
                                        .frame(width: 4, height: 2)
                                }
                            }
                            .padding(.vertical, 2)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(20)
                    
                    Divider().background(Color.tGray)

                    Text("아동이 생성한 도서가 이곳에 표시됩니다.")
                        .font(.NotoSans_16_R)
                        .foregroundColor(Color.textGray)
                        .padding(20)
                        .clipShape(RoundedRectangle(cornerRadius: 26))
                }
            }
        }
    }

    // MARK: - 도서 완독률
    private var quizAccuracyCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("도서 완독률")
                    .font(.NotoSans_16_SB)
                Spacer()
                Text("\(Int((viewModel.quizAccuracyProgress * 100).rounded()))%")
                    .font(.NotoSans_16_SB)
                    .foregroundColor(.main)
            }
            .padding(.bottom, 20)

            ProgressBar(
                progress: viewModel.quizAccuracyProgress,
                height: .h8,
                style: .purple,
                backColor: .lightgray
            )
            .padding(.bottom, 6)

            HStack(spacing: 0){
                Spacer()
                Text("\(viewModel.quizAccuracy.correctCount)/\(viewModel.quizAccuracy.totalCount)")
                    .font(.NotoSans_12_R)
                    .foregroundColor(.textGray)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(26)
    }

    // MARK: - wcpm graph
    private var wcpmCard: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("주간 WCPM(읽기 유창성) 점수")
                    .font(.NotoSans_16_SB)
                Spacer()
                Image(.info)
            }
            
            VStack(spacing: 0){
                ZStack {
                    chartBackground
                            
                    BarChart(
                        data: viewModel.wcpm.daily.map {
                            ChartData(
                                label: String(format: "%.1f", $0.value),
                                value: $0.value
                            )
                        },
                        thresholds: [viewModel.wcpm.average],
                        maxValue: 90,
                        barStyle: AnyShapeStyle(
                            LinearGradient(
                                colors: [.main, .point],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    )
                }
                .padding(20)
                .frame(height: 157)

                Divider()
                    .background(Color.tGray)
                        
                Button {
                    print("목록 펼치기 클릭")
                } label: {
                    VStack(spacing: 4) {
                        Text("도서 목록 펼치기")
                            .font(.NotoSans_16_R)
                        Image(.rightGray)
                            .rotationEffect(.degrees(90))
                    }
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                }
            }
            .background(Color.white)
            .cornerRadius(26)
        }
    }

    private var chartBackground: some View {
        VStack(spacing: 0) {
            ForEach(0..<5) { index in
                Rectangle()
                    .fill(index % 2 == 0 ? Color.graphGray : Color.clear)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: index == 0 ? 6 : 0,
                            bottomLeadingRadius: index == 4 ? 6 : 0,
                            bottomTrailingRadius: index == 4 ? 6 : 0,
                            topTrailingRadius: index == 0 ? 6 : 0
                        )
                    )
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.bottom, 18)
    }
    
    // MARK: - footer
    private var reportFooter: some View {
        
        VStack(spacing: 0) {

            Divider()
                .background(Color.tGray)

            Spacer()

            Image(.logoFlatPurple)
                .resizable()
                .scaledToFit()
                .frame(width: 46, height: 24)

            Spacer()
        }
    }
}

#Preview {
    WeeklyReportView()
}
