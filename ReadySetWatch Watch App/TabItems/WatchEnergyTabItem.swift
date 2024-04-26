//
//  WatchEnergyTabItem.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import Foundation
import SwiftUI

struct WatchEnergyTabItem: IWatchTabItem {
    var text = "Energy"
    var type = WatchTabItemType.energy
    var icon = "Flame"
    var color = Color.orangeStart
    var secondaryColor = Color.orangeEnd
    var gradient = LinearGradient(colors: [.orangeEnd, .orangeStart], startPoint: .topLeading, endPoint: .bottomTrailing)
}
