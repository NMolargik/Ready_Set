//
//  EnergyChartView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/16/24.
//

import SwiftUI
import Charts

struct EnergyChartView: View {
    @AppStorage("useMetric") var useMetric: Bool = false
    @ObservedObject var energyViewModel: EnergyViewModel

    var averageEnergyConsumed: Double {
        let totalEnergy = energyViewModel.energyConsumedWeek.values.reduce(0, +)
        return totalEnergy > 0 ? Double(totalEnergy) / Double(energyViewModel.energyConsumedWeek.count) : 0
    }
        
    var averageEnergyBurned: Double {
        let totalEnergy = energyViewModel.energyBurnedWeek.values.reduce(0, +)
        return totalEnergy > 0 ? Double(totalEnergy) / Double(energyViewModel.energyBurnedWeek.count) : 0
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ChartView(title: "Energy Consumed", yLabel: useMetric ? "KiloJoules" : "Calories", unitLabel: useMetric ? "kJ" : "cal", color: .orange, data: $energyViewModel.energyConsumedWeek, average: .constant(averageEnergyConsumed), goal: $energyViewModel.energyGoal, showGoal: true)
            
            ChartView(title: "Energy Burned", yLabel: useMetric ? "KiloJoules" : "Calories", unitLabel: useMetric ? "kJ" : "cal", color: .red, data: $energyViewModel.energyBurnedWeek, average: .constant(averageEnergyBurned), goal: $energyViewModel.energyGoal, showGoal: false)
        }
    }
}

#Preview {
    EnergyChartView(energyViewModel: EnergyViewModel())
}
