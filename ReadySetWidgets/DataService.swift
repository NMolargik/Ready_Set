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

    @ObservedObject var energyViewModel: EnergyViewModel = .shared
    @ObservedObject var waterViewModel: WaterViewModel = .shared

    @AppStorage("useMetric", store: UserDefaults(suiteName: Bundle.main.groupID)) var useMetric: Bool = false

    @AppStorage("waterGoal", store: UserDefaults(suiteName: Bundle.main.groupID)) var waterGoal: Double = 64

    @AppStorage("waterConsumedToday", store: UserDefaults(suiteName: Bundle.main.groupID)) var waterConsumedToday: Int = 0

    @AppStorage("energyGoal", store: UserDefaults(suiteName: Bundle.main.groupID)) var energyGoal: Double = 2000

    @AppStorage("energyConsumedToday", store: UserDefaults(suiteName: Bundle.main.groupID)) var energyConsumedToday: Int = 0

    func addSomeWater() {
        DispatchQueue.main.async {
            let value = useMetric ? 240 : 8
            waterViewModel.addWater(waterToAdd: Double(value))
        }
    }

    func addSomeEnergy() {
        DispatchQueue.main.async {
            let value = useMetric ? 800 : 200
            energyViewModel.addEnergy(energy: Double(value))
        }
    }
}
