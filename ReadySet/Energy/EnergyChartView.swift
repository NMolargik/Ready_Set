//
//  EnergyChartView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/16/24.
//

import SwiftUI
import Charts

struct EnergyChartView: View {
    @State var energyViewModel: EnergyViewModel

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
            ChartView(title: "Energy Consumed", yLabel: energyViewModel.useMetric ? "KiloJoules" : "Calories", unitLabel: energyViewModel.useMetric ? "kJ" : "cal", color: .orange, showGoal: true, data: $energyViewModel.energyConsumedWeek, average: .constant(averageEnergyConsumed), goal: $energyViewModel.energyGoalObserved)

            ChartView(title: "Energy Burned", yLabel: energyViewModel.useMetric ? "KiloJoules" : "Calories", unitLabel: energyViewModel.useMetric ? "kJ" : "cal", color: .red, showGoal: false, data: $energyViewModel.energyBurnedWeek, average: .constant(averageEnergyBurned), goal: $energyViewModel.energyGoalObserved)
        }
    }
}

#Preview {
    EnergyChartView(energyViewModel: EnergyViewModel())
}
