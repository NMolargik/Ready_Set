//
//  BottomView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct BottomView: View {
    @ObservedObject var waterViewModel: WaterViewModel
    @ObservedObject var calorieViewModel: CalorieViewModel
    
    @Binding var selectedTab: any ITabItem
    
    var body: some View {
        Group {
            switch (selectedTab.type) {
            case .exercise:
                ExerciseBottomContentView()
            case .water:
                WaterBottomContentView(waterViewModel: waterViewModel)
            case .calorie:
                CalorieBottomContentView(calorieViewModel: calorieViewModel)
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
    BottomView(waterViewModel: WaterViewModel(), calorieViewModel: CalorieViewModel(), selectedTab: .constant(ExerciseTabItem()))
}
