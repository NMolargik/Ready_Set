//
//  EnergyTabItem.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import Foundation
import SwiftUI

struct EnergyTabItem: ITabItem {
    var text = "Energy"
    var type = TabItemType.Energy
    var icon = "Flame"
    var color = Color.orangeStart
    var secondaryColor = Color.orangeEnd
    var gradient = LinearGradient(colors: [.orangeEnd, .orangeStart], startPoint: .topLeading, endPoint: .bottomTrailing)
    var sheetPresentationDetent = PresentationDetent.fraction(0.3)
    
    func bumpTab(up: Bool) -> any ITabItem {
        return up ? WaterTabItem() : SettingsTabItem()
    }
    
    func reorderTabs() -> [any ITabItem] {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        return [EnergyTabItem(), SettingsTabItem(), ExerciseTabItem(), WaterTabItem()]
    }
}
