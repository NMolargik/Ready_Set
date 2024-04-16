//
//  WaterChartView.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/16/24.
//

import Foundation
import SwiftUI

struct WaterChartView: View {
    let data: [Date: Int]

    var body: some View {
        VStack {
            Text("Water Consumption Chart")
                .font(.title)
                .padding()

            // Chart View
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(Array(data.keys.sorted()), id: \.self) { date in
                        VStack {
                            Text("\(formattedDate(date))")
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 50, height: CGFloat(data[date]!))
                        }
                    }
                }
                .padding()
            }
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
    WaterChartView(data: [
        Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 15))!: 16,
        Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 16))!: 44
    ])
}

