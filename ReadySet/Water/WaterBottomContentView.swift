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
                WaterChartView(waterViewModel: waterViewModel)
                
                Spacer()
                
                WaterAdditionWidgetView(waterViewModel: waterViewModel)
            }
            .padding(.top, 20)
            
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 15)
        .onAppear {
            withAnimation {
                waterViewModel.readWaterConsumedWeek()
            }
        }
    }
}

#Preview {
    WaterBottomContentView(waterViewModel: WaterViewModel())
}
