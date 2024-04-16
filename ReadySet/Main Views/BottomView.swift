//
//  BottomView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct BottomView: View {
    @ObservedObject var waterViewModel: WaterViewModel
    @ObservedObject var energyViewModel: EnergyViewModel
    
    @Binding var selectedTab: any ITabItem
    
    var body: some View {
        Group {
            switch (selectedTab.type) {
            case .exercise:
                ExerciseBottomContentView()
            case .water:
                WaterBottomContentView(waterViewModel: waterViewModel)
            case .Energy:
                EnergyBottomContentView(energyViewModel: energyViewModel)
            case .settings:
                SettingsBottomContentView()
            }
        }
        .animation(.smooth(duration: 0.2), value: selectedTab.type)
        .transition(.opacity)
        .padding(.top, 8)
    }
}

#Preview {
    BottomView(waterViewModel: WaterViewModel(), energyViewModel: EnergyViewModel(), selectedTab: .constant(ExerciseTabItem()))
}
