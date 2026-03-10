//
//  BarChart.swift
//  Totori
//
//  Created by 복지희 on 3/5/26.
//

import SwiftUI

struct ChartData: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
}

struct BarChart: View {
    let data: [ChartData]
    let thresholds: [Double]
    let maxValue: Double
    let barStyle: AnyShapeStyle
    
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
                        VStack(spacing: 0) {
                            barView(
                                value: item.value,
                                chartHeight: chartHeight
                            )
                            
                            Text(item.label)
                                .font(.NotoSans_12_R)
                                .frame(height: labelHeight, alignment: .center)
                        }
                        .frame(maxWidth: .infinity)
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
        chartHeight: CGFloat
    ) -> some View {
        let barHeight = chartHeight * CGFloat(value / maxValue)
        
        return VStack(spacing: 0) {
            Spacer(minLength: 0)
            Rectangle()
                .fill(barStyle)
                .frame(width: 8, height: barHeight)
        }
        .frame(height: chartHeight)
    }
}
