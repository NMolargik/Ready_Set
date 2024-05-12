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
        VStack {
            WaterChartView(waterViewModel: waterViewModel)

            Spacer()

            WaterAdditionWidgetView(
                addWater: { water in
                    waterViewModel.addWater(waterToAdd: water)
                }
            )
        }
        .padding(.top, 20)
    }
}

#Preview {
    WaterBottomContentView(waterViewModel: WaterViewModel())
}
