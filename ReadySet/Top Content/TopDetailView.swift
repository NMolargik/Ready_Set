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
            WaterTopContentView()
                .transition(.opacity)
        case .calorie:
            CalorieTopContentView()
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
