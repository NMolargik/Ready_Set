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
    @Binding var selectedDay: Int

    var body: some View {
        ZStack {
            ZStack {
                Rectangle()
                    .cornerRadius(35)
                    .foregroundStyle(.ultraThinMaterial)
                    .shadow(radius: 1)
                    .animation(.easeInOut(duration: 0.5), value: selectedTab.type)

                Group {
                    switch selectedTab.type {
                    case .exercise:
                        ExerciseBottomContentView(exerciseViewModel: exerciseViewModel, selectedDay: $selectedDay)
                    case .water:
                        WaterBottomContentView(waterViewModel: waterViewModel)
                    case .energy:
                        EnergyBottomContentView(energyViewModel: energyViewModel)
                    case .settings:
                        SettingsBottomContentView()
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: selectedTab.type)
                .mask {
                    Rectangle()
                        .cornerRadius(35)
                }
            }
            .geometryGroup()
            .transition(.opacity)
        }
    }
}

#Preview {
    BottomView(exerciseViewModel: ExerciseViewModel(), waterViewModel: WaterViewModel(), energyViewModel: EnergyViewModel(), selectedTab: .constant(ExerciseTabItem()), selectedDay: .constant(0))
}
