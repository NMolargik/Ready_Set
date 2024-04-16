//
//  WaterChartView.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/16/24.
//

import SwiftUI
import Charts

struct WaterChartView: View {
    @ObservedObject var waterViewModel: WaterViewModel

    var averageWaterConsumed: Double {
        let totalWater = waterViewModel.waterConsumedWeek.values.reduce(0, +)
        return totalWater > 0 ? Double(totalWater) / Double(waterViewModel.waterConsumedWeek.count) : 0
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ChartView(title: "Water Consumed", color: .blueEnd, data: $waterViewModel.waterConsumedWeek, average: .constant(averageWaterConsumed), goal: $waterViewModel.waterGoal, showGoal: true)
        }
    }
}

#Preview {
    WaterChartView(waterViewModel: WaterViewModel())
}