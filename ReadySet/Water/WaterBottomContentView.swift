//
//  WaterBottomContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI
import Charts

struct WaterBottomContentView: View {
    @ObservedObject var waterViewModel: WaterViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(35)
                .foregroundStyle(.ultraThinMaterial)
                .shadow(radius: 1)
            
            VStack {
                Spacer()
                
                WaterChartView(data: waterViewModel.waterConsumedWeek)
                WaterAdditionWidgetView(waterViewModel: waterViewModel)
                
                //TODO: Add water chart
                //SAMPLE
//                Chart {
//                    ForEach(catData) { data in
//                        LineMark(x: .value("Year", data.year),
//                                 y: .value("Population", data.population))
//                    }
//                    .interpolationMethod(.cardinal)
//                    .symbol(by: .value("Pet type", "cat"))
//
//                    ForEach(catData) { data in
//                        AreaMark(x: .value("Year", data.year),
//                                 y: .value("Population", data.population))
//                    }
//                    .interpolationMethod(.cardinal)
//                    .foregroundStyle(linearGradient)
//                }
//                .chartXScale(domain: 1998...2024)
//                .chartLegend(.hidden)
//                .chartXAxis {
//                    AxisMarks(values: [2000, 2010, 2015, 2022]) { value in
//                        AxisGridLine()
//                        AxisTick()
//                        if let year = value.as(Int.self) {
//                            AxisValueLabel(formatte(number: year),
//                                           centered: false,
//                                           anchor: .top)
//                        }
//                    }
//                }
//                .aspectRatio(1, contentMode: .fit)
//                .padding()
            }
            
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 15)
        .onAppear {
            waterViewModel.readWaterConsumedWeek()
            print("Buh")
            print(waterViewModel.waterConsumedWeek)
        }
    }
}

#Preview {
    WaterBottomContentView(waterViewModel: WaterViewModel())
}
