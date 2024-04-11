//
//  WaterTabItem.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import Foundation
import SwiftUI

struct WaterTabItem: ITabItem {
    var text = "Water"
    var type = TabItemType.water
    var icon = "Droplet"
    var color = Color.blue
    var gradient = LinearGradient(colors: [.blueEnd, .blueStart], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    func bumpTab(up: Bool) -> any ITabItem {
        return up ? ExerciseTabItem() : CalorieTabItem()
    }
    
    func reorderTabs() -> [any ITabItem] {
        return [WaterTabItem(), CalorieTabItem(), SettingsTabItem(), ExerciseTabItem()]

    }
}

