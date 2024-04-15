//
//  TopView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct TopDetailView: View {
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    @ObservedObject var waterViewModel: WaterViewModel
    @ObservedObject var calorieViewModel: CalorieViewModel

    @Binding var selectedTab: any ITabItem
    var body: some View {
        Group {
            switch (selectedTab.type) {
            case .exercise:
                ExerciseTopContentView(exerciseViewModel: exerciseViewModel)
                    .transition(.opacity)
            case .water:
                WaterTopContentView(waterViewModel: waterViewModel)
                    .transition(.opacity)
            case .calorie:
                CalorieTopContentView(calorieViewModel: calorieViewModel)
                    .transition(.opacity)
            case .settings:
                SettingsTopContentView()
                    .transition(.opacity)
            }
        }
        .frame(height: 85)
    }
}
    
#Preview {
    TopDetailView(exerciseViewModel: ExerciseViewModel(), waterViewModel: WaterViewModel(), calorieViewModel: CalorieViewModel(), selectedTab: .constant(ExerciseTabItem()))
}
