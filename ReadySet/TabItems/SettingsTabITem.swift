//
//  SettingsTabItem.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct SettingsTabItem: ITabItem {
    var text = "Settings"
    var type = TabItemType.settings
    var icon = "Cog"
    var color = Color.purpleStart
    var secondaryColor = Color.purpleEnd
    var gradient = LinearGradient(colors: [.purpleStart, .purpleEnd], startPoint: .topLeading, endPoint: .bottomTrailing)

    func bumpTab(up: Bool) -> any ITabItem {
        return up ? EnergyTabItem() : ExerciseTabItem()
    }

    func reorderTabs() -> [any ITabItem] {
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        #endif
        return [SettingsTabItem(), ExerciseTabItem(), WaterTabItem(), EnergyTabItem()]
    }
}
