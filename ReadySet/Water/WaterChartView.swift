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
    
    var averageOunces: Double {
        let totalOunces = waterViewModel.waterConsumedWeek.values.reduce(0, +)
        return totalOunces > 0 ? Double(totalOunces) / Double(waterViewModel.waterConsumedWeek.count) : 0
    }

    var body: some View {
        VStack (spacing: 0) {
            Text("Water Consumption")
                .bold()
                .font(.title3)
                .foregroundStyle(.fontGray)
            
            Chart {
                ForEach(Array(waterViewModel.waterConsumedWeek).sorted(by: { $0.key < $1.key }), id: \.key) { (date, ounces) in
                    LineMark(
                        x: .value("Date", date),
                        y: .value("Ounces", ounces)
                    )
                }
                .foregroundStyle(.blue)
                .interpolationMethod(.cardinal)
                .symbol(.circle)
                
                ForEach(Array(waterViewModel.waterConsumedWeek).sorted(by: { $0.key < $1.key }), id: \.key) { (date, ounces) in
                    AreaMark(
                        x: .value("Date", date),
                        y: .value("Ounces", ounces)
                    )
                }
                .interpolationMethod(.cardinal)
                .foregroundStyle(LinearGradient(colors: [.blueEnd, .clear], startPoint: .top, endPoint: .bottom))
                
                RuleMark(
                    y: .value("Average Ounces", averageOunces)
                )
                .foregroundStyle(LinearGradient(colors: [.blueEnd, .base], startPoint: .leading, endPoint: .trailing))
                .annotation(position: .top, alignment: .leading) {
                    Text("Avg: \(Int(averageOunces))oz")
                        .bold()
                        .font(.caption)
                        .foregroundColor(.primary)
                        .opacity(0.7)
                        .padding(.leading, 4)
                }
                
                RuleMark(
                    y: .value("Goal", waterViewModel.waterGoal)
                )
                .opacity(0.7)
                .foregroundStyle(LinearGradient(colors: [.blueEnd, .base], startPoint: .leading, endPoint: .trailing))
                .annotation(position: .top, alignment: .leading) {
                    Text("Goal: \(Int(waterViewModel.waterGoal))oz")
                        .bold()
                        .font(.caption)
                        .foregroundColor(.primary)
                        .opacity(0.7)
                        .padding(.leading, 4)
                }
            }
            .animation(.easeInOut, value: waterViewModel.waterConsumedWeek)
            .chartXAxisLabel("Date")
            .chartYAxisLabel("Ounces")
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisGridLine()
                    AxisTick()
                    if let date = value.as(Date.self) {
                        AxisValueLabel(formattedDate(date))
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .padding()
        }
    }

    // Helper function to format Date to String
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    WaterChartView(waterViewModel: WaterViewModel())
}

