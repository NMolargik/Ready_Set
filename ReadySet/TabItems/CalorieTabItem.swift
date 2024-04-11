//
//  CalorieTabItem.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import Foundation
import SwiftUI

struct CalorieTabItem: ITabItem {
    var text = "Calories"
    var type = TabItemType.calorie
    var selectedIconName = "flame.fill"
    var unselectedIconName = "flame"
    var color = Color.orange
    var gradient = LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    func bumpTab(up: Bool) -> any ITabItem {
        return up ? WaterTabItem() : SettingsTabItem()
    }
    
    func reorderTabs() -> [any ITabItem] {
        return [CalorieTabItem(), SettingsTabItem(), ExerciseTabItem(), WaterTabItem()]
    }
}

