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
                ForEach(Array(thresholds.enumerated()), id: \.offset) { index, threshold in
                    let lineColor = (index == 1) ? Color.textGray : Color.point
                    
                    thresholdLineView(
                        value: threshold,
                        chartHeight: chartHeight,
                        width: chartWidth,
                        color: lineColor
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
                                    .foregroundStyle(isSelected ? .black : .textGray)
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
        width: CGFloat,
        color: Color
    ) -> some View {
        let yPosition = chartHeight * (1 - CGFloat(value / maxValue))
        
        return HStack(spacing: 4) {
            Rectangle()
                .fill(color)
                .frame(height: 1)
            
            Text("\(String(format: "%.0f", value))")
                .font(.NotoSans_12_R)
                .foregroundStyle(color)
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
