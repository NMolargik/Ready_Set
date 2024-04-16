//
//  EnergyChartView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/16/24.
//

import SwiftUI
import Charts

struct EnergyChartView: View {
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
            ChartView(title: "Energy Consumed", color: .orange, data: $energyViewModel.energyConsumedWeek, average: .constant(averageEnergyConsumed), goal: $energyViewModel.energyGoal, showGoal: true)
            
            ChartView(title: "Energy Burned", color: .red, data: $energyViewModel.energyBurnedWeek, average: .constant(averageEnergyBurned), goal: $energyViewModel.energyGoal, showGoal: false)
        }
    }
}

#Preview {
    EnergyChartView(energyViewModel: EnergyViewModel())
}
