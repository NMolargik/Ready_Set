//
//  MetricTabItem.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import Foundation
import SwiftUI

struct MetricTabItem: ITabItem {
    var text = "Metrics"
    var type = TabItemType.metrics
    var selectedIconName = "chart.xyaxis.line"
    var unselectedIconName = "chart.xyaxis.line"
    var color = Color.purple
    
    func bumpTab(up: Bool) -> any ITabItem {
        return up ? ExerciseTabItem() : WaterTabItem()
    }
    
    func reorderTabs() -> [any ITabItem] {
        return [MetricTabItem(), WaterTabItem(), CalorieTabItem(), ExerciseTabItem()]

    }
}

