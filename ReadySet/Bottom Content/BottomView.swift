//
//  BottomView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct BottomView: View {
    @Binding var selectedTab: any ITabItem
    var body: some View {
        switch (selectedTab.type) {
        case .exercise:
            ExerciseBottomContentView()
        case .water:
            WaterBottomContentView()
        case .calorie:
            CalorieBottomContentView()
        case .settings:
            SettingsBottomContentView()
        }
    }
}

#Preview {
    BottomView(selectedTab: .constant(ExerciseTabItem()))
}
