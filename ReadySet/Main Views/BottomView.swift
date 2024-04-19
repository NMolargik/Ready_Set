//
//  BottomView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct BottomView: View {
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    @ObservedObject var waterViewModel: WaterViewModel
    @ObservedObject var energyViewModel: EnergyViewModel
    
    @Binding var selectedTab: any ITabItem
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(35)
                .foregroundStyle(.ultraThinMaterial)
                .shadow(radius: 1)
                .animation(.easeInOut(duration: 0.5), value: selectedTab.type)
            
            Group {
                switch (selectedTab.type) {
                case .exercise:
                    ExerciseBottomContentView(exerciseViewModel: exerciseViewModel)
                case .water:
                    WaterBottomContentView(waterViewModel: waterViewModel)
                case .Energy:
                    EnergyBottomContentView(energyViewModel: energyViewModel)
                case .settings:
                    SettingsBottomContentView()
                }
            }
            .animation(.easeInOut(duration: 0.2), value: selectedTab.type)
        }
        .transition(.opacity)
    }
}

#Preview {
    BottomView(exerciseViewModel: ExerciseViewModel(), waterViewModel: WaterViewModel(), energyViewModel: EnergyViewModel(), selectedTab: .constant(ExerciseTabItem()))
}
