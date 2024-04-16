//
//  CalorieChartView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/16/24.
//

import SwiftUI
import Charts

struct CalorieChartView: View {
    @ObservedObject var calorieViewModel: CalorieViewModel

    var averageCaloriesConsumed: Double {
        let totalCalories = calorieViewModel.caloriesConsumedWeek.values.reduce(0, +)
        return totalCalories > 0 ? Double(totalCalories) / Double(calorieViewModel.caloriesConsumedWeek.count) : 0
    }
        
    var averageCaloriesBurned: Double {
        let totalCalories = calorieViewModel.caloriesBurnedWeek.values.reduce(0, +)
        return totalCalories > 0 ? Double(totalCalories) / Double(calorieViewModel.caloriesBurnedWeek.count) : 0
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ChartView(title: "Calories Consumed", color: .orange, data: $calorieViewModel.caloriesConsumedWeek, average: .constant(averageCaloriesConsumed), goal: $calorieViewModel.calorieGoal, showGoal: true)
            
            ChartView(title: "Calories Burned", color: .red, data: $calorieViewModel.caloriesBurnedWeek, average: .constant(averageCaloriesBurned), goal: $calorieViewModel.calorieGoal, showGoal: false)
        }
    }
}

#Preview {
    CalorieChartView(calorieViewModel: CalorieViewModel())
}
