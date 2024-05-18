//
//  WaterViewModel.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import SwiftUI
import HealthKit
import Foundation
import WidgetKit

@Observable class WaterViewModel: HKHelper {
    static let shared = WaterViewModel()

    @ObservationIgnored @AppStorage("disableWave", store: UserDefaults(suiteName: Bundle.main.groupID)) var disableWave: Bool = false
    @ObservationIgnored @AppStorage("useMetric", store: UserDefaults(suiteName: Bundle.main.groupID)) var useMetric: Bool = false
    @ObservationIgnored @AppStorage("decreaseHaptics") var decreaseHaptics: Bool = false
    @ObservationIgnored @AppStorage("waterGoal", store: UserDefaults(suiteName: Bundle.main.groupID)) var waterGoal: Double = 64 {
        didSet {
            waterGoalObserved = waterGoal
            WidgetCenter.shared.reloadTimelines(ofKind: "ReadySetWaterWidget")
        }
    }

    @ObservationIgnored @AppStorage("waterConsumedToday", store: UserDefaults(suiteName: Bundle.main.groupID)) var waterConsumedToday: Int = 0 {
        didSet {
            waterConsumedTodayObserved = waterConsumedToday
            WidgetCenter.shared.reloadTimelines(ofKind: "ReadySetWaterWidget")
        }
    }

    var waterConsumedTodayObserved = 0
    var waterGoalObserved: Double = 0
    var proposedWaterGoal = 64
    var editingWaterGoal = false
    var waterConsumedWeek: [Date: Int] = [:]
    var healthStore: HKHealthStore = HealthBaseController.shared.healthStore
    var waterSliderValue: Double = 8 {
        didSet {
            if !decreaseHaptics {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
            self.proposedWaterGoal = Int(waterSliderValue)
        }
    }

    var watchConnector: WatchConnector = .shared

    init() {
        self.proposedWaterGoal = Int(self.waterGoal)
        self.readInitial()
        self.waterGoalObserved = waterGoal
    }

    func readInitial() {
        self.readWaterConsumedToday()
        self.readWaterConsumedWeek()
    }

    func addWater(waterToAdd: Double) {
        DispatchQueue.main.async {
            self.addWaterConsumed(waterAmount: waterToAdd) {
                withAnimation(.easeInOut) {
                    self.readWaterConsumedToday()
                    self.readWaterConsumedWeek()
                }
            }
        }
    }

    func addSomeWater() {
        self.addWater(waterToAdd: useMetric ? 240 : 8)
    }

    private func readWaterConsumedToday() {
        let unit = self.useMetric ? HKUnit.literUnit(with: .milli) : HKUnit.fluidOunceUS()
        hkQuery(type: waterConsumed, unit: unit, failed: "Failed to read water gallons today") { amount in
            DispatchQueue.main.async {
                self.waterConsumedToday = amount
                self.watchConnector.sendUpdateToWatch(update: ["waterBalance": amount])
            }
        }
    }

    private func readWaterConsumedWeek() {
        let unit = self.useMetric ? HKUnit.literUnit(with: .milli) : HKUnit.fluidOunceUS()
        let end = Date().endOfDay
        let start = end.addingDays(-6).startOfDay
        hkColQuery(type: waterConsumed, start: start, end: end, unit: unit, failed: "Error while reading water during week") { day, amount in
            DispatchQueue.main.async {
                self.waterConsumedWeek[day] = amount
            }
        }
    }

    private func addWaterConsumed(waterAmount: Double, completion: @escaping () -> Void) {
        let waterSample = HKQuantitySample(type: waterConsumed, quantity: HKQuantity(unit: self.useMetric ? HKUnit.literUnit(with: .milli) : HKUnit.fluidOunceUS(), doubleValue: waterAmount), start: Date(), end: Date())

        healthStore.save(waterSample, withCompletion: { (success, error) -> Void in

            if error != nil {
                print("HealthKit - Error - \(String(describing: error))")
            }

            if success {
                print("HealthKit - Success - Water successfully saved in HealthKit")

            } else {
                print("HealthKit - Error - Water Consumed Unhandled case!")
            }

            self.readWaterConsumedToday()
            completion()
        })
    }

    func saveWaterGoal() {
        self.waterGoal = Double(self.proposedWaterGoal)
        self.editingWaterGoal = false
        self.watchConnector.sendUpdateToWatch(update: ["waterGoal": waterGoal])
    }
}
