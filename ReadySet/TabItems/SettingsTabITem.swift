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
    var sheetPresentationDetent = PresentationDetent.fraction(0)
    
    func bumpTab(up: Bool) -> any ITabItem {
        return up ? EnergyTabItem() : ExerciseTabItem()
    }
    
    func reorderTabs() -> [any ITabItem] {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        return [SettingsTabItem(), ExerciseTabItem(), WaterTabItem(), EnergyTabItem()]

    }
}

