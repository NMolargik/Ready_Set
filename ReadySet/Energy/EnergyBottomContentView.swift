//
//  EnergyBottomContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct EnergyBottomContentView: View {
    @ObservedObject var energyViewModel: EnergyViewModel
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(35)
                .foregroundStyle(.ultraThinMaterial)
                .shadow(radius: 1)
            
            VStack {
                EnergyChartView(energyViewModel: energyViewModel)
                
                Spacer()
                
                EnergyAdditionWidgetView(
                    addEnergy: { energy in
                        energyViewModel.addEnergy(energy: energy)
                    }
                )
            }
            .padding(.top, 20)
            
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 15)
        .onAppear {
            withAnimation {
                energyViewModel.readEnergyBurnedWeek()
                energyViewModel.readEnergyConsumedWeek()
            }
        }
    }
}

#Preview {
    EnergyBottomContentView(energyViewModel: EnergyViewModel())
}
