//
//  EnergyTabItem.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct EnergyTabItem: ITabItem {
    var text = "Energy"
    var type = TabItemType.energy
    var icon = "Flame"
    var color = Color.orangeStart
    var secondaryColor = Color.orangeEnd
    var gradient = LinearGradient(colors: [.orangeEnd, .orangeStart], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    func bumpTab(up: Bool) -> any ITabItem {
        return up ? WaterTabItem() : SettingsTabItem()
    }
    
    func reorderTabs() -> [any ITabItem] {
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        #endif
        return [EnergyTabItem(), SettingsTabItem(), ExerciseTabItem(), WaterTabItem()]
    }
}
