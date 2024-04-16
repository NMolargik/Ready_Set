//
//  CalorieBottomContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct CalorieBottomContentView: View {
    @ObservedObject var calorieViewModel: CalorieViewModel
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(35)
                .foregroundStyle(.ultraThinMaterial)
                .shadow(radius: 1)
            
            VStack {
                CalorieChartView(calorieViewModel: calorieViewModel)
                
                Spacer()
                
                CalorieAdditionWidgetView(calorieViewModel: calorieViewModel)
            }
            .padding(.top, 20)
            
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 15)
        .onAppear {
            withAnimation {
                calorieViewModel.readEnergyBurnedWeek()
                calorieViewModel.readEnergyConsumedWeek()
            }
        }
    }
}

#Preview {
    CalorieBottomContentView(calorieViewModel: CalorieViewModel())
}
