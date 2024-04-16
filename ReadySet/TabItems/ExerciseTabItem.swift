//
//  ExerciseTabItem.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import Foundation
import SwiftUI

struct ExerciseTabItem: ITabItem {
    let text = "Exercise"
    var type = TabItemType.exercise
    var icon = "Dumbbell"
    var color = Color.greenEnd
    var secondaryColor = Color.greenStart
    var gradient = LinearGradient(colors: [.greenEnd, .greenStart], startPoint: .topLeading, endPoint: .bottomTrailing)
    var sheetPresentationDetent = PresentationDetent.fraction(0.9)
    
    
    func bumpTab(up: Bool) -> any ITabItem {
        return up ? SettingsTabItem() : WaterTabItem()
    }
    
    func reorderTabs() -> [any ITabItem] {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        return [ExerciseTabItem(), WaterTabItem(), EnergyTabItem(), SettingsTabItem()]
    }
}
