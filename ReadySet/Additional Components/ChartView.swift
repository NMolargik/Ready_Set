//
//  ChartView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/16/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    var title: String
    var yLabel: String
    var unitLabel: String
    var color: Color
    @Binding var data: [Date: Int]
    @Binding var average: Double
    @Binding var goal: Double
    var showGoal: Bool
    
    var body: some View {
        Group {
            Text(title)
                .bold()
                .font(.title3)
                .foregroundStyle(color)
                .shadow(radius: 2)
            
            Chart {
                ForEach(Array(data).sorted(by: { $0.key < $1.key }), id: \.key) { (date, value) in
                    LineMark(x: .value("Date", date), y: .value(title, value))
                }
                .interpolationMethod(.cardinal)
                .foregroundStyle(color)
                .symbol(.circle)
                
                ForEach(Array(data).sorted(by: { $0.key < $1.key }), id: \.key) { (date, value) in
                    AreaMark(x: .value("Date", date), y: .value(title, value))
                }
                .interpolationMethod(.cardinal)
                .foregroundStyle(LinearGradient(colors: [color, .clear], startPoint: .top, endPoint: .bottom))
                .foregroundStyle(color)
                
                RuleMark(y: .value("Average \(title)", average))
                .foregroundStyle(LinearGradient(colors: [color, .base], startPoint: .leading, endPoint: .trailing))
                .annotation(position: .top, alignment: .leading) {
                    Text("Avg: \(Int(average))\(unitLabel)")
                        .bold()
                        .font(.caption)
                        .foregroundColor(.primary)
                        .opacity(0.7)
                        .padding(.leading, 4)
                }
                
                if (showGoal) {
                    RuleMark(y: .value("Goal \(title)", goal))
                    .foregroundStyle(LinearGradient(colors: [color, .base], startPoint: .leading, endPoint: .trailing))
                    .annotation(position: .top, alignment: .leading) {
                        Text("Goal: \(Int(goal))\(unitLabel)")
                            .bold()
                            .font(.caption)
                            .foregroundColor(.primary)
                            .opacity(0.7)
                            .padding(.leading, 4)
                    }
                }
            }
            .animation(.easeInOut, value: data)
            .chartXAxisLabel("Date")
            .chartYAxisLabel(yLabel)
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
    ChartView(title: "Chart", yLabel: "Ounces", unitLabel: "oz", color: Color.white, data: .constant([:]), average: .constant(0), goal: .constant(0), showGoal: true)
}
