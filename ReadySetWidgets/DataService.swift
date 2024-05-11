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
    
    func addSomeWater() {
        //TODO: this is problematic. this is never reflected on healthkit, and as such the main app never reflects it either
        self.waterConsumedToday += useMetric ? 240 : 8
    }
    
    func addSomeEnergy() {
        //TODO: this is problematic. this is never reflected on healthkit, and as such the main app never reflects it either
        self.energyConsumedToday += useMetric ? 800 : 200
    }

}
