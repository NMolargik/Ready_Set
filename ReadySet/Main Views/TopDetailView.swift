//
//  TopView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct TopDetailView: View {
    @State var exerciseViewModel: ExerciseViewModel
    @State var waterViewModel: WaterViewModel
    @State var energyViewModel: EnergyViewModel

    @Binding var selectedTab: any ITabItem
    var body: some View {
        Group {
            switch selectedTab.type {
            case .exercise:
                ExerciseTopContentView(exerciseViewModel: exerciseViewModel)
                    .transition(.opacity)
            case .water:
                WaterTopContentView(waterViewModel: waterViewModel)
                    .transition(.opacity)
            case .energy:
                EnergyTopContentView(energyViewModel: energyViewModel)
                    .transition(.opacity)
            case .settings:
                SettingsTopContentView(exerciseViewModel: exerciseViewModel)
                    .transition(.opacity)
            }
        }
        .frame(height: 85)
    }
}

#Preview {
    TopDetailView(exerciseViewModel: ExerciseViewModel(), waterViewModel: WaterViewModel(), energyViewModel: EnergyViewModel(), selectedTab: .constant(ExerciseTabItem()))
}
