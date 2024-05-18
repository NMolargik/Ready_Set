//
//  DataService.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 5/9/24.
//

import Foundation
import SwiftUI
import WidgetKit

struct DataService {
    static let shared = DataService()
    @State var energy: EnergyViewModel = .shared
    @State var water: WaterViewModel = .shared

    @AppStorage("useMetric", store: UserDefaults(suiteName: Bundle.main.groupID)) var useMetric: Bool = false

    @AppStorage("waterGoal", store: UserDefaults(suiteName: Bundle.main.groupID)) var waterGoal: Double = 64 {
        didSet {
            WidgetCenter.shared.reloadTimelines(ofKind: "ReadySetWaterWidget")
        }
    }

    @AppStorage("waterConsumedToday", store: UserDefaults(suiteName: Bundle.main.groupID)) var waterConsumedToday: Int = 0 {
        didSet {
            WidgetCenter.shared.reloadTimelines(ofKind: "ReadySetWaterWidget")
        }
    }
    
    @AppStorage("waterIncrementValue", store: UserDefaults(suiteName: Bundle.main.groupID)) var waterIncrementValue: Double = 0

    @AppStorage("energyGoal", store: UserDefaults(suiteName: Bundle.main.groupID)) var energyGoal: Double = 2000 {
        didSet {
            WidgetCenter.shared.reloadTimelines(ofKind: "ReadySetEnergyWidget")
        }
    }

    @AppStorage("energyConsumedToday", store: UserDefaults(suiteName: Bundle.main.groupID)) var energyConsumedToday: Int = 0 {
        didSet {
            WidgetCenter.shared.reloadTimelines(ofKind: "ReadySetEnergyWidget")
        }
    }
    
    @AppStorage("energyIncrementValue", store: UserDefaults(suiteName: Bundle.main.groupID)) var energyIncrementValue: Double = 1000
}
