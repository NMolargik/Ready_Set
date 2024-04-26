//
//  WatchWaterTabItem.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import Foundation
import SwiftUI

struct WatchWaterTabItem: IWatchTabItem {
    var text = "Water"
    var type = WatchTabItemType.water
    var icon = "Droplet"
    var color = Color.blueEnd
    var secondaryColor = Color.blueStart
    var gradient = LinearGradient(colors: [.blueEnd, .blueStart], startPoint: .topLeading, endPoint: .bottomTrailing)
}
