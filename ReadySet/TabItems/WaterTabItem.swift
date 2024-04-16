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
    var color = Color.blueEnd
    var secondaryColor = Color.blueStart
    var gradient = LinearGradient(colors: [.blueEnd, .blueStart], startPoint: .topLeading, endPoint: .bottomTrailing)
    var sheetPresentationDetent = PresentationDetent.fraction(0.3)
    
    func bumpTab(up: Bool) -> any ITabItem {
        return up ? ExerciseTabItem() : EnergyTabItem()
    }
    
    func reorderTabs() -> [any ITabItem] {
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()
        return [WaterTabItem(), EnergyTabItem(), SettingsTabItem(), ExerciseTabItem()]

    }
}

