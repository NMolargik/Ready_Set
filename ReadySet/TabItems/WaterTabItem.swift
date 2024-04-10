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
    
    func bumpTab(up: Bool) -> any ITabItem {
        return up ? MetricTabItem() : CalorieTabItem()
    }
    
    func reorderTabs() -> [any ITabItem] {
        return [WaterTabItem(), CalorieTabItem(), ExerciseTabItem(), MetricTabItem()]

    }
}

