//
//  TotalReportView.swift
//  Totori
//
//  Created by 복지희 on 3/12/26.
//

import SwiftUI

struct TotalReportView: View {

    @StateObject private var viewModel = TotalReportViewModel()
    
    @State private var showWCPMPopOver = false
    @State private var showAnalysisPopOver = false

    var body: some View {
        ZStack {
            VStack(spacing: 20) {

                CustomNavigationBar(
                    centerType: .text("전체레포트"),
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

                        wcpmCard
                            .padding(.horizontal, 20)
                        
                        wrongAnalysisCard
                            .padding(.horizontal, 20)
                        
                        reportFooter
                    }
                }
            }
            .background(Color.backgroundGray)
            .navigationBarHidden(true)
            
            if showWCPMPopOver || showAnalysisPopOver {
                Color.clear
                    .contentShape(Rectangle())
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showWCPMPopOver = false
                            showAnalysisPopOver = false
                        }
                    }
            }
        }
    }

    // MARK: - wcpm graph
    
    private var wcpmCard: some View {
        let diff = viewModel.wcpm.childAverage - viewModel.wcpm.average
        let yAxisBuffer: Double = 20.0
        
        return VStack(spacing: 20){
            HStack {
                Text("종합 WCPM(읽기 유창성) 점수")
                    .font(.NotoSans_16_SB)
                
                Spacer()
                
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showWCPMPopOver.toggle()
                    }
                } label: {
                    Image(.info)
                }
                .buttonStyle(.plain)
                .overlay(alignment: .topTrailing) {
                    if showWCPMPopOver {
                        PopOverCard(
                            title: "WCPM(읽기 유창성)이란?",
                            descript: "현대에서 보편적으로 사용하는 유창\n성 지표 중 하나로, 글을 얼마나 빠르\n고 정확하게 읽는지 나타냅니다."
                        )
                        .offset(x: 30, y: 25)
                    }
                }
            }
            .zIndex(1)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            ZStack {
                chartBackground
                        
                BarChart(
                    data: viewModel.wcpm.total.map {
                        ChartData(
                            id: $0.id,
                            label: $0.displayMonth,
                            value: $0.wcpm
                        )
                    },
                    thresholds: [viewModel.wcpm.average, viewModel.wcpm.childAverage],
                    maxValue: viewModel.wcpm.maxWcpm + yAxisBuffer,
                    barStyle: AnyShapeStyle(Color.main),
                    selectedId: .constant(nil)
                )
                .allowsHitTesting(false)
            }
            .padding(.horizontal, 20)
            .frame(height: 180)

            Divider()
                .background(Color.tGray)
            
            (
                Text("아동 WCPM(읽기 유창성)평균 점수는 ")
                    .font(.NotoSans_16_R)
                    .foregroundStyle(.black)
                
                + Text("\(String(format: "%.0f", viewModel.wcpm.average))점")
                    .font(.NotoSans_16_SB)
                    .foregroundStyle(.main)
                
                + Text("으로,\n아동 평균인 ")
                    .font(.NotoSans_16_R)
                    .foregroundStyle(.black)
                
                + Text("\(String(format: "%.0f", viewModel.wcpm.childAverage))점")
                    .font(.NotoSans_16_SB)
                    .foregroundStyle(.main)
                
                + Text("보다 ")
                    .font(.NotoSans_16_R)
                    .foregroundStyle(.black)
                
                + Text("\(Int(abs(diff)))점 \(diff >= 0 ? "낮" : "높")습니다.")
                    .font(.NotoSans_16_SB)
                    .foregroundStyle(.main)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 26)
                .fill(Color.white)
        )
    }

    private var chartBackground: some View {
        HStack(spacing: 0) {
            ForEach(0..<6) { index in
                Rectangle()
                    .fill(index % 2 == 0 ? Color.tLightGray : Color.clear)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: index == 0 ? 6 : 0,
                            bottomLeadingRadius: index == 0 ? 6 : 0,
                            bottomTrailingRadius: index == 6 ? 6 : 0,
                            topTrailingRadius: index == 6 ? 6 : 0
                        )
                    )
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 10)
    }
    
    // MARK: - 오답 유형 분석
    
    private var wrongAnalysisCard: some View {
        
        VStack(spacing: 0){
            HStack {
                Text("오답 유형 분석")
                    .font(.NotoSans_16_SB)
                
                Spacer()
                
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showAnalysisPopOver.toggle()
                    }
                } label: {
                    Image(.info)
                }
                .buttonStyle(.plain)
                .overlay(alignment: .topTrailing) {
                    if showAnalysisPopOver {
                        PopOverCard(
                            title: "오답 유형 분석표",
                            descript: "아동이 동화를 읽으면서 발생하는 발\n음의 오차 및 유형을 나타냅니다."
                        )
                        .offset(x: 30, y: 25)
                    }
                }
            }
            .zIndex(1)
            .padding(20)

            ForEach(viewModel.wrong, id: \.label) { item in
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 0) {
                        Text(item.label)
                            .font(.NotoSans_12_R)
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Text("\(item.wrongCount)/\(item.totalCount)")
                            .font(.NotoSans_12_R)
                            .foregroundStyle(.textGray)
                    }
                    ProgressBar(
                        progress: CGFloat(item.progress),
                        height: .h7,
                        style: viewModel.getChartStyle(progress: item.progress),
                        backColor: .lightgray
                    )
                    .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 12)
        .background(
            RoundedRectangle(cornerRadius: 26)
                .fill(Color.white)
        )
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
    TotalReportView()
}
