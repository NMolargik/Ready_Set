//
//  TabItemType.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

enum TabItemType {
    case exercise
    case water
    case Energy
    case settings

    //iOS
    
    
    static var allItems: [any ITabItem] {
        #if os(iOS)
        [ExerciseTabItem(), WaterTabItem(), EnergyTabItem(), SettingsTabItem()]
        #else
        [ExerciseTabItem(), WaterTabItem(), EnergyTabItem()]
        #endif
    }
    
    static func shiftItems(forward: Bool) -> [any ITabItem] {
        var shiftedItems = allItems
        if forward {
            let firstItem = shiftedItems.removeFirst()
            shiftedItems.append(firstItem)
        } else {
            let lastItem = shiftedItems.removeLast()
            shiftedItems.insert(lastItem, at: 0)
        }
        
        return shiftedItems
    }
}
