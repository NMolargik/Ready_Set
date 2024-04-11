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
    var selectedIconName = "drop.fill"
    var unselectedIconName = "drop"
    var color = Color.blue
    var gradient = LinearGradient(colors: [.cyan, .blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    func bumpTab(up: Bool) -> any ITabItem {
        return up ? ExerciseTabItem() : CalorieTabItem()
    }
    
    func reorderTabs() -> [any ITabItem] {
        return [WaterTabItem(), CalorieTabItem(), SettingsTabItem(), ExerciseTabItem()]

    }
}

