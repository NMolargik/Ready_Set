//
//  TopView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct TopDetailView: View {
    @Binding var selectedTab: any ITabItem
    var body: some View {
        switch (selectedTab.type) {
        case .exercise:
            ExerciseTopContentView()
                .transition(.opacity)
        case .water:
            WaterTopContentView(progress: 0.5)
                .transition(.opacity)
        case .calorie:
            CalorieTopContentView(progress: 0.5)
                .transition(.opacity)
        case .settings:
            SettingsTopContentView()
                .transition(.opacity)
        }
    }
}
    
#Preview {
    TopDetailView(selectedTab: .constant(ExerciseTabItem()))
}
