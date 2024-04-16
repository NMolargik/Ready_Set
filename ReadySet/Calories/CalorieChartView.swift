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
        VStack (spacing: 0) {
            Text("Calories Consumed")
                .bold()
                .font(.title3)
                .foregroundStyle(.orangeEnd)
                .opacity(0.8)
                .shadow(radius: 2)
            
            Chart {
                ForEach(Array(calorieViewModel.caloriesConsumedWeek).sorted(by: { $0.key < $1.key }), id: \.key) { (date, caloriesConsumed) in
                    LineMark(
                        x: .value("Date", date),
                        y: .value("Calories Consumed", caloriesConsumed)
                    )
                }
                .interpolationMethod(.cardinal)
                .foregroundStyle(.orange)
                .symbol(.circle)
                
                ForEach(Array(calorieViewModel.caloriesConsumedWeek).sorted(by: { $0.key < $1.key }), id: \.key) { (date, caloriesConsumed) in
                    AreaMark(
                        x: .value("Date", date),
                        y: .value("Calories Consumed", caloriesConsumed)
                    )
                }
                .interpolationMethod(.cardinal)
                .foregroundStyle(LinearGradient(colors: [.orangeEnd, .clear], startPoint: .top, endPoint: .bottom))

                RuleMark(
                    y: .value("Average Calories Consumed", averageCaloriesConsumed)
                )
                .foregroundStyle(LinearGradient(colors: [.orangeEnd, .base], startPoint: .leading, endPoint: .trailing))
                .annotation(position: .top, alignment: .leading) {
                    Text("Avg: \(Int(averageCaloriesConsumed))cal")
                        .bold()
                        .font(.caption)
                        .foregroundColor(.primary)
                        .opacity(0.7)
                        .padding(.leading, 4)
                }
                
                RuleMark(
                    y: .value("Goal", calorieViewModel.calorieGoal)
                )
                .opacity(0.7)
                .foregroundStyle(LinearGradient(colors: [.orangeEnd, .base], startPoint: .leading, endPoint: .trailing))
                .annotation(position: .top, alignment: .leading) {
                    Text("Goal: \(Int(calorieViewModel.calorieGoal))cal")
                        .bold()
                        .font(.caption)
                        .foregroundColor(.primary)
                        .opacity(0.7)
                        .padding(.leading, 4)
                }
            }
            .animation(.easeInOut, value: calorieViewModel.caloriesConsumedWeek)
            .chartXAxisLabel("Date")
            .chartYAxisLabel("Calories")
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisGridLine()
                    AxisTick()
                    if let date = value.as(Date.self) {
                        AxisValueLabel(formattedDate(date))
                    }
                }
            }
            .padding()
            
            Text("Calories Burned")
                .bold()
                .font(.title3)
                .foregroundStyle(.orangeStart)
                .opacity(0.8)
                .shadow(radius: 2)
            
            Chart {
                ForEach(Array(calorieViewModel.caloriesBurnedWeek).sorted(by: { $0.key < $1.key }), id: \.key) { (date, caloriesBurned) in
                    LineMark(
                        x: .value("Date", date),
                        y: .value("Calories Burned", caloriesBurned)
                    )
                }
                .interpolationMethod(.cardinal)
                .foregroundStyle(.yellow)
                .symbol(.circle)
                
                ForEach(Array(calorieViewModel.caloriesBurnedWeek).sorted(by: { $0.key < $1.key }), id: \.key) { (date, caloriesBurned) in
                    AreaMark(
                        x: .value("Date", date),
                        y: .value("Calories Burned", caloriesBurned)
                    )
                }
                .interpolationMethod(.cardinal)
                .foregroundStyle(LinearGradient(colors: [.orangeStart, .clear], startPoint: .top, endPoint: .bottom))
                
                
                
                RuleMark(
                    y: .value("Average Calories Burned", averageCaloriesBurned)
                )
                .foregroundStyle(LinearGradient(colors: [.orangeStart, .base], startPoint: .leading, endPoint: .trailing))
                .annotation(position: .top, alignment: .leading) {
                    Text("Avg: \(Int(averageCaloriesBurned))cal")
                        .bold()
                        .font(.caption)
                        .foregroundColor(.primary)
                        .opacity(0.7)
                        .padding(.leading, 4)
                }
            }
            .animation(.easeInOut, value: calorieViewModel.caloriesBurnedWeek)
            .chartXAxisLabel("Date")
            .chartYAxisLabel("Calories")
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisGridLine()
                    AxisTick()
                    if let date = value.as(Date.self) {
                        AxisValueLabel(formattedDate(date))
                    }
                }
            }
            .padding()
        }
    }

    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    CalorieChartView(calorieViewModel: CalorieViewModel())
}
