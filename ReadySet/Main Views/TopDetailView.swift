//
//  TopView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct TopDetailView: View {
    @ObservedObject var waterViewModel: WaterViewModel
    
    @Binding var selectedTab: any ITabItem
    var body: some View {
        Group {
            switch (selectedTab.type) {
            case .exercise:
                ExerciseTopContentView()
                    .transition(.opacity)
            case .water:
                WaterTopContentView(waterViewModel: waterViewModel)
                    .transition(.opacity)
            case .calorie:
                CalorieTopContentView(progress: 0.5)
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
    TopDetailView(waterViewModel: WaterViewModel(), selectedTab: .constant(ExerciseTabItem()))
}
