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

    private init() {
        scheduleReset()
    }

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

    func resetWaterConsumption() {
        waterConsumedToday = 0
        print("Consumption reset to zero at midnight.")
        // You might want to post a notification here to update the widget
        NotificationCenter.default.post(name: .consumptionReset, object: nil)
    }

    func resetEnergyConsumption() {
        energyConsumedToday = 0
        print("Consumption reset to zero at midnight.")
        // You might want to post a notification here to update the widget
        NotificationCenter.default.post(name: .consumptionReset, object: nil)
    }

    private func scheduleReset() {
        // Calculate time interval until next midnight
        let now = Date()
        let calendar = Calendar.current
        if let nextMidnight = calendar.date(bySettingHour: 0, minute: 0, second: 1, of: now.addingTimeInterval(86400)) {
            let timeInterval = nextMidnight.timeIntervalSince(now)

            // Schedule timer
            Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
                self.resetWaterConsumption()
                self.resetEnergyConsumption()
                self.scheduleReset()
            }
        }
    }
}

extension Notification.Name {
    static let consumptionReset = Notification.Name("consumptionReset")
}
