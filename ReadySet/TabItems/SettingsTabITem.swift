//
//  SettingsTabItem.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import Foundation
import SwiftUI

struct SettingsTabItem: ITabItem {
    var text = "Settings"
    var type = TabItemType.settings
    var icon = "Cog"
    var color = Color.purple
    var gradient = LinearGradient(colors: [.purpleEnd, .purpleStart], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    func bumpTab(up: Bool) -> any ITabItem {
        return up ? CalorieTabItem() : ExerciseTabItem()
    }
    
    func reorderTabs() -> [any ITabItem] {
        return [SettingsTabItem(), ExerciseTabItem(), WaterTabItem(), CalorieTabItem()]

    }
}

