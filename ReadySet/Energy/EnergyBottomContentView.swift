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
        VStack {
            EnergyChartView(energyViewModel: energyViewModel)

            Spacer()

            EnergyAdditionComponentView(
                addEnergy: { energy in
                    energyViewModel.addEnergy(energy: energy)
                }
            )
        }
        .padding(.top, 20)
    }
}

#Preview {
    EnergyBottomContentView(energyViewModel: EnergyViewModel())
}
