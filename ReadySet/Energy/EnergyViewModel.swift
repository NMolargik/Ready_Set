//
//  EnergyViewModel.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/14/24.
//

import SwiftUI
import HealthKit
import WidgetKit

@Observable class EnergyViewModel: HKHelper {
    static let shared = EnergyViewModel()

    @ObservationIgnored @AppStorage("useMetric", store: UserDefaults(suiteName: Bundle.main.groupID)) var useMetric: Bool = false
    @ObservationIgnored @AppStorage("decreaseHaptics") var decreaseHaptics: Bool = false
    @ObservationIgnored @AppStorage("energyGoal", store: UserDefaults(suiteName: Bundle.main.groupID)) var energyGoal: Double = 2000 {
        didSet {
            self.energyGoalObserved = energyGoal
            WidgetCenter.shared.reloadTimelines(ofKind: "ReadySetEnergyWidget")
        }
    }

    @ObservationIgnored @AppStorage("energyConsumedToday", store: UserDefaults(suiteName: Bundle.main.groupID)) var energyConsumedToday: Int = 0 {
        didSet {
            self.energyConsumedTodayObserved = energyConsumedToday
            WidgetCenter.shared.reloadTimelines(ofKind: "ReadySetEnergyWidget")
        }
    }
    
    @ObservationIgnored @AppStorage("energyIncrementValue", store: UserDefaults(suiteName: Bundle.main.groupID)) var energyIncrementValue: Double = 1000 {
        didSet {
            energyIncrementValueObserved = energyIncrementValue
        }
    }

    var energyConsumedTodayObserved = 0
    var energyGoalObserved: Double = 0
    var energyIncrementValueObserved: Double = 1000
    var proposedEnergyGoal = 0
    var editingEnergyGoal = false
    var energyConsumedWeek: [Date: Int] = [:]
    var energyBurnedToday: Int = 0
    var energyBurnedWeek: [Date: Int] = [:]
    var healthStore: HKHealthStore = HealthBaseController.shared.healthStore
    var energysliderValue: Double = 0 {
        didSet {
            if !decreaseHaptics {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
            self.proposedEnergyGoal = Int(energysliderValue)
        }
    }

    var watchConnector: WatchConnector = .shared

    init() {
        self.proposedEnergyGoal = Int(self.energyGoal)
        self.readInitial()
        self.energyGoalObserved = energyGoal
    }

    func readInitial() {
        self.readEnergyConsumedToday()
        self.readEnergyBurnedToday()
        self.readEnergyBurnedWeek()
        self.readEnergyConsumedWeek()
    }

    func addEnergy(energy: Double) {
        print("Value: energy=\(energy)\n\(#file):\(#line)")
        DispatchQueue.main.async {
            self.addEnergyConsumed(energy: energy) {
                withAnimation(.easeInOut) {
                    self.readEnergyConsumedToday()
                    self.readEnergyConsumedWeek()
                    self.readEnergyBurnedWeek()
                    self.readEnergyBurnedToday()
                }
            }
        }
    }

    func consumeSomeEnergy() {
        self.addEnergy(energy: energyIncrementValueObserved)
    }

    private func readEnergyConsumedToday() {
        let unit = self.useMetric ? HKUnit.jouleUnit(with: .kilo) : HKUnit.kilocalorie()
        hkQuery(type: energyConsumed, unit: unit, failed: "Failed to read energy consumed today") { amount in
            DispatchQueue.main.async {
                self.energyConsumedToday = amount
                self.watchConnector.sendUpdateToWatch(update: ["energyBalance": amount])
            }
        }
        WidgetCenter.shared.reloadTimelines(ofKind: "ReadySetEnergyWidget")
    }

    private func readEnergyConsumedWeek() {
        let unit = self.useMetric ? HKUnit.jouleUnit(with: .kilo) : HKUnit.kilocalorie()
        let end = Date().endOfDay
        let start = end.addingDays(-6).startOfDay
        hkColQuery(type: energyConsumed, start: start, end: end, unit: unit, failed: "Error while reading consumed calories during week") { day, amount in
            DispatchQueue.main.async {
                self.energyConsumedWeek[day] = amount
            }
        }
    }

    private func readEnergyBurnedToday() {
        let unit = self.useMetric ? HKUnit.jouleUnit(with: .kilo) : HKUnit.kilocalorie()
        hkQuery(type: energyBurned, unit: unit, failed: "Failed to read energy burned today") { amount in
            DispatchQueue.main.async {
                self.energyBurnedToday = amount
            }
        }
    }

    private func readEnergyBurnedWeek() {
        let unit = self.useMetric ? HKUnit.jouleUnit(with: .kilo) : HKUnit.kilocalorie()
        let end = Date().endOfDay
        let start = end.addingDays(-6).startOfDay
        hkColQuery(type: energyBurned, start: start, end: end, unit: unit, failed: "Error while reading burned calories during week") { day, amount in
            DispatchQueue.main.async {
                self.energyBurnedWeek[day] = amount
            }
        }
    }

    private func addEnergyConsumed(energy: Double, completion: @escaping () -> Void) {
        print("Value: healthStore=\(self.healthStore.debugDescription)\nValue: energy=\(energy)\n\(#file):\(#line)")
        let energysample = HKQuantitySample(type: energyConsumed, quantity: HKQuantity(unit: self.useMetric ? HKUnit.jouleUnit(with: .kilo) : HKUnit.kilocalorie(), doubleValue: energy), start: Date(), end: Date())
        self.healthStore.save(energysample, withCompletion: { (success, error) -> Void in
            print("Value: energy=\(energy)\n\(#file):\(#line)")
            if error != nil {
                print("HealthKit - Error - \(String(describing: error))")
            }

            if success {
                print("HealthKit - Success - Energy successfully saved in HealthKit")

            } else {
                print("HealthKit - Error - Energy consumed unhandled case!")
            }

            self.readEnergyConsumedToday()
            completion()

        })
    }

    func saveEnergyGoal() {
        self.energyGoal = Double(self.proposedEnergyGoal)
        self.editingEnergyGoal = false
        self.watchConnector.sendUpdateToWatch(update: ["energyGoal": energyGoal])
    }
}
