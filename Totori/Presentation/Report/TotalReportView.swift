//
//  TotalReportView.swift
//  Totori
//
//  Created by 복지희 on 3/12/26.
//

import SwiftUI

struct TotalReportView: View {

    @StateObject private var viewModel = TotalReportViewModel()

    var body: some View {
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
    }

    // MARK: - wcpm graph
    
    private var wcpmCard: some View {
        let diff = viewModel.wcpm.childAverage - viewModel.wcpm.average
        
        return VStack(spacing: 20){
            HStack {
                Text("종합 WCPM(읽기 유창성) 점수")
                    .font(.NotoSans_16_SB)
                Spacer()
                Image(.info)
            }
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
                    maxValue: 90,
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
                    .foregroundColor(.black)
                
                + Text("\(String(format: "%.0f", viewModel.wcpm.average))점")
                    .font(.NotoSans_16_SB)
                    .foregroundColor(.main)
                
                + Text("으로,\n아동 평균인 ")
                    .font(.NotoSans_16_R)
                    .foregroundColor(.black)
                
                + Text("\(String(format: "%.0f", viewModel.wcpm.childAverage))점")
                    .font(.NotoSans_16_SB)
                    .foregroundColor(.main)
                
                + Text("보다 ")
                    .font(.NotoSans_16_R)
                    .foregroundColor(.black)
                
                + Text("\(Int(abs(diff)))점 \(diff >= 0 ? "낮" : "높")습니다.")
                    .font(.NotoSans_16_SB)
                    .foregroundColor(.main)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color.white)
        .cornerRadius(26)
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
                Image(.info)
            }
            .padding(20)

            ForEach(viewModel.wrong, id: \.label) { item in
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 0) {
                        Text(item.label)
                            .font(.NotoSans_12_R)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text("\(item.wrongCount)/\(item.totalCount)")
                            .font(.NotoSans_12_R)
                            .foregroundColor(.textGray)
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
        .background(Color.white)
        .cornerRadius(26)
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
