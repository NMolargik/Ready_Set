//
//  WatchExerciseTabItem.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import Foundation
import SwiftUI

struct WatchExerciseTabItem: IWatchTabItem {
    let text = "Exercise"
    var type = WatchTabItemType.exercise
    var icon = "Dumbbell"
    var color = Color.greenEnd
    var secondaryColor = Color.greenStart
    var gradient = LinearGradient(colors: [.greenEnd, .greenStart], startPoint: .topLeading, endPoint: .bottomTrailing)
}
