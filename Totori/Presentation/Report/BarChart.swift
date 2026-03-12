//
//  BarChart.swift
//  Totori
//
//  Created by 복지희 on 3/5/26.
//

import SwiftUI

struct ChartData: Identifiable {
    let id: Int
    let label: String
    let value: Double
}

struct BarChart: View {
    let data: [ChartData]
    let thresholds: [Double]
    let maxValue: Double
    let barStyle: AnyShapeStyle
    
    @Binding var selectedId: Int?
    
    private let labelHeight: CGFloat = 18
    
    var body: some View {
        GeometryReader { geometry in
            let chartHeight = geometry.size.height - labelHeight
            let chartWidth = geometry.size.width
            
            ZStack(alignment: .topLeading) {
                
                // Threshold Lines
                ForEach(thresholds, id: \.self) { threshold in
                    thresholdLineView(
                        value: threshold,
                        chartHeight: chartHeight,
                        width: chartWidth
                    )
                }
                
                // Bar + Label
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(data) { item in
                        let isSelected = (selectedId == nil) || (selectedId == item.id)
                        
                        Button {
                            selectedId = (selectedId == item.id) ? nil : item.id
                        } label: {
                            VStack(spacing: 0){
                                barView(
                                    value: item.value,
                                    chartHeight: chartHeight,
                                    isSelected: isSelected
                                )
                                    
                                Text(item.label)
                                    .font(.NotoSans_12_R)
                                    .foregroundColor(isSelected ? .black : .textGray)
                                    .frame(height: labelHeight, alignment: .center)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                }
                .padding(.horizontal, 10)
                .frame(width: chartWidth, height: geometry.size.height)
            }
        }
    }
    
    // MARK: - Subviews
    
    private func thresholdLineView(
        value: Double,
        chartHeight: CGFloat,
        width: CGFloat
    ) -> some View {
        let yPosition = chartHeight * (1 - CGFloat(value / maxValue))
        
        return HStack(spacing: 4) {
            Rectangle()
                .fill(Color.point)
                .frame(height: 1)
            
            Text("\(Int(value))")
                .font(.NotoSans_12_R)
                .foregroundColor(Color.point)
        }
        .position(x: width / 2, y: yPosition)
    }
    
    private func barView(
        value: Double,
        chartHeight: CGFloat,
        isSelected: Bool
    ) -> some View {
        let barHeight = chartHeight * CGFloat(value / maxValue)
        
        return VStack(spacing: 0) {
            Spacer(minLength: 0)
            Rectangle()
                .fill(isSelected ? barStyle : AnyShapeStyle(Color.tGray))
                .frame(width: 8, height: barHeight)
        }
        .frame(height: chartHeight)
    }
}

#Preview {
    // 💡 1. 상태를 관리해 줄 가짜 부모 뷰(Wrapper)를 만듭니다.
    struct BarChartPreviewWrapper: View {
        @State private var selectedChartId: Int? = nil
        
        var body: some View {
            BarChart(
                data: [
                    ChartData(id: 1, label: "67.0", value: 67),
                    ChartData(id: 2, label: "81.0", value: 81),
                    ChartData(id: 3, label: "70.0", value: 70),
                    ChartData(id: 4, label: "60.0", value: 60),
                    ChartData(id: 5, label: "66.0", value: 66),
                    ChartData(id: 6, label: "62.0", value: 62),
                    ChartData(id: 7, label: "79.0", value: 79)
                ],
                thresholds: [73.0],
                maxValue: 100.0,
                barStyle: AnyShapeStyle(
                    LinearGradient(
                        colors: [.purple, .pink],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                ),
                // 💡 2. 래퍼 뷰의 상태 변수를 바인딩으로 넘겨줍니다.
                selectedId: $selectedChartId
            )
            .frame(height: 200)
            .padding(20)
            .background(Color.white)
        }
    }
    
    // 💡 3. 프리뷰에서는 래퍼 뷰를 렌더링합니다.
    return BarChartPreviewWrapper()
}
