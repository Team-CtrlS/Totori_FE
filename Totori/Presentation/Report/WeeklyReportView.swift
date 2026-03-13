//
//  WeeklyReportView.swift
//  Totori
//
//  Created by 복지희 on 3/4/26.
//

import SwiftUI

struct WeeklyReportView: View {

    @StateObject private var viewModel = WeeklyReportViewModel()
    
    @State private var isBookListExpanded: Bool = false
    @State private var selectedChartId: Int? = nil
    @State private var showPopOver = false
    @State private var isNavigatingToTotal: Bool = false

    var body: some View {
        NavigationStack{
            ZStack{
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
                                isNavigatingToTotal = true
                            }
                            .padding(.horizontal, 20)
                            
                            reportFooter
                        }
                    }
                }
                .background(Color.backgroundGray)
                .navigationBarHidden(true)
                
                .navigationDestination(isPresented: $isNavigatingToTotal) {
                    TotalReportView()
                }
                
                if showPopOver {
                    Color.clear
                        .contentShape(Rectangle())
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showPopOver = false
                            }
                        }
                }
            }
        }
    }

    // MARK: - 주간 학습 현황
    private var weeklyLearningCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("주간 학습 현황")
                .font(.NotoSans_16_SB)
                .foregroundColor(Color.black)
            
            VStack(spacing: 0) {
                daySelection
                
                Divider().background(Color.tGray)

                if !viewModel.selectedBooks.isEmpty {
                    VStack(spacing: 0) {
                        // TODO: 클릭하면 해당 도서설명 부분으로 이동
                        ForEach(viewModel.selectedBooks) { book in
                            HStack(spacing: 4) {
                                Image(book.isCompleted ? .bookmarkPink : .bookmarkLightGray)

                                Text(book.title)
                                    .font(.NotoSans_16_R)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Image(.rightGray)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        }
                    }
                    .padding(.vertical, 20)
                } else {
                    Text("아동이 생성한 도서가 이곳에 표시됩니다.")
                        .font(.NotoSans_16_R)
                        .foregroundColor(Color.textGray)
                        .padding(40)
                        .frame(maxWidth: .infinity)
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 26))
        }
    }
    
    private var daySelection: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.weeklyLearning) { day in
                let isSelected = viewModel.selectedDate == day.date
                
                Button {
                    viewModel.selectedDate = day.date
                } label: {
                    VStack(spacing: 0) {
                        Text(day.dayOfWeek.koreanShort)
                            .font(isSelected ? .NotoSans_16_SB : .NotoSans_16_R)
                            .foregroundColor(day.dayOfWeek.isWeekend ? .tRed :.textGray)
                            .padding(.bottom, 10)

                        Image(day.studied ? .acornActive : .acornDeactive)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 26)
                            .padding(.bottom, 2)

                        HStack(spacing: 2) {
                            ForEach(0..<min(day.bookCount, 3), id: \.self) { _ in
                                Circle()
                                    .fill(Color.main)
                                    .frame(width: 4, height: 4)
                            }
                        }
                        .frame(height: 4)
                        .padding(.bottom, 2)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 72)
                    .background(isSelected ? Color.main20 : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
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
        
        let yAxisBuffer: Double = 20.0
        
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("주간 WCPM(읽기 유창성) 점수")
                    .font(.NotoSans_16_SB)
                
                Spacer()
                
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showPopOver.toggle()
                    }
                } label: {
                    Image(.info)
                }
                .buttonStyle(.plain)
                .overlay(alignment: .topTrailing) {
                    if showPopOver {
                        PopOverCard(
                            title: "WCPM(읽기 유창성)이란?",
                            descript: "현대에서 보편적으로 사용하는 유창\n성 지표 중 하나로, 글을 얼마나 빠르\n고 정확하게 읽는지 나타냅니다."
                        )
                        .offset(x: 10, y: 25)
                    }
                }
            }
            .zIndex(1)
            
            VStack(spacing: 0){
                ZStack {
                    chartBackground
                            
                    BarChart(
                        data: viewModel.wcpm.daily.map {
                            ChartData(
                                id: $0.id,
                                label: String(format: "%.1f", $0.wcpm),
                                value: $0.wcpm
                            )
                        },
                        thresholds: [viewModel.wcpm.average],
                        maxValue: viewModel.wcpm.maxWcpm + yAxisBuffer,
                        barStyle: AnyShapeStyle(
                            LinearGradient(
                                colors: [.main, .point],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        ),
                        selectedId: $selectedChartId
                    )
                    .allowsHitTesting(isBookListExpanded)
                }
                .padding(20)
                .frame(height: 157)

                Divider()
                    .background(Color.tGray)
                
                if isBookListExpanded {
                    VStack(spacing: 0) {
                        ForEach(viewModel.wcpm.daily) { daily in
                            wcpmBook(wcpmDaily: daily)
                        }
                    }
                    .padding(.vertical, 8)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
                        
                Button {
                    withAnimation(.easeInOut) {
                        isBookListExpanded.toggle()
                        selectedChartId = nil
                    }
                } label: {
                    VStack(spacing: 4) {
                        if !isBookListExpanded {
                            Text("도서 목록 펼치기")
                                .font(.NotoSans_16_R)
                            Image(.rightGray)
                                .rotationEffect(.degrees(90))
                        } else {
                            Image(.rightGray)
                                .rotationEffect(.degrees(270))
                                .padding(.bottom, 10)
                        }
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
    
    @ViewBuilder
    private func wcpmBook(wcpmDaily: WCPMDaily) -> some View {
        
        let isSpecificallySelected = (selectedChartId == wcpmDaily.id)
        HStack(spacing: 4) {
            Text(wcpmDaily.book)
                .font(.NotoSans_16_R)
                .foregroundColor(.black)
            
            Spacer()
            
            Text(String(wcpmDaily.wcpm))
                .font(isSpecificallySelected ? .NotoSans_16_SB : .NotoSans_16_R)
                .foregroundColor(isSpecificallySelected ? .mainVariation : .textGray)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(isSpecificallySelected ? Color.main20 : Color.clear)
        .contentShape(Rectangle())
            .onTapGesture {
                selectedChartId = isSpecificallySelected ? nil : wcpmDaily.id
            }
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
