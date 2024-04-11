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
    var icon = "Dumbbell"
    var color = Color.green
    var gradient = LinearGradient(colors: [.greenEnd, .greenStart], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    func bumpTab(up: Bool) -> any ITabItem {
        return up ? SettingsTabItem() : WaterTabItem()
    }
    
    func reorderTabs() -> [any ITabItem] {
        return [ExerciseTabItem(), WaterTabItem(), CalorieTabItem(), SettingsTabItem()]
    }
}
