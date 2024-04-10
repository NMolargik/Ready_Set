//
//  ExerciseTabItem.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import Foundation
import SwiftUI

struct ExerciseTabItem: ITabItem {
    var text = "Exercise"
    var type = TabItemType.exercise
    var selectedIconName = "dumbbell.fill"
    var unselectedIconName = "dumbbell"
    var color = Color.green
    
    func bumpTab(up: Bool) -> any ITabItem {
        return up ? CalorieTabItem() : MetricTabItem()
    }
    
    func reorderTabs() -> [any ITabItem] {
        return [ExerciseTabItem(), MetricTabItem(), WaterTabItem(), CalorieTabItem()]
    }
}
