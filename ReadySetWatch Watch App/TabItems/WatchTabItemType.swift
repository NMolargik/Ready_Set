//
//  TabItemType.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import Foundation

enum WatchTabItemType {
    case exercise
    case water
    case energy

    static var allItems: [any IWatchTabItem] {
        [WatchExerciseTabItem(), WatchWaterTabItem(), WatchEnergyTabItem()]
    }
}
