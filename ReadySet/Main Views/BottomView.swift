//
//  BottomView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct BottomView: View {
    @ObservedObject var waterViewModel: WaterViewModel
    
    @Binding var selectedTab: any ITabItem
    
    var body: some View {
        Group {
            switch (selectedTab.type) {
            case .exercise:
                ExerciseBottomContentView()
            case .water:
                WaterBottomContentView(waterViewModel: waterViewModel)
            case .calorie:
                CalorieBottomContentView()
            case .settings:
                SettingsBottomContentView()
            }
        }
        .animation(.smooth(duration: 0.2))
        .transition(.opacity)
        .padding(.top, 8)
    }
}

#Preview {
    BottomView(waterViewModel: WaterViewModel(), selectedTab: .constant(ExerciseTabItem()))
}
