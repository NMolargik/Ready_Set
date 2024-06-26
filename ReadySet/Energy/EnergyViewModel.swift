//
//  EnergyViewModel.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/14/24.
//

import SwiftUI
import HealthKit
import WidgetKit

class EnergyViewModel: ObservableObject, HKHelper {
    static let shared = EnergyViewModel()

    @AppStorage("useMetric", store: UserDefaults(suiteName: Bundle.main.groupID)) var useMetric: Bool = false
    @AppStorage("decreaseHaptics") var decreaseHaptics: Bool = false
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

    @Published var proposedEnergyGoal = 0
    @Published var editingEnergyGoal = false
    @Published var energyConsumedWeek: [Date: Int] = [:]
    @Published var energyBurnedToday: Int = 0
    @Published var energyBurnedWeek: [Date: Int] = [:]
    @Published var healthStore: HKHealthStore = HealthBaseController.shared.healthStore
    @Published var energySliderValue: Double = 8 {
        didSet {
            if !decreaseHaptics {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
            self.proposedEnergyGoal = Int(energySliderValue)
        }
    }

    var watchConnector: WatchConnector = .shared

    init() {
        self.proposedEnergyGoal = Int(self.energyGoal)
        self.readInitial()
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

    func readEnergyConsumedToday() {
        let unit = self.useMetric ? HKUnit.jouleUnit(with: .kilo) : HKUnit.kilocalorie()
        hkQuery(type: energyConsumed, unit: unit, failed: "Failed to read energy consumed today") { amount in
            DispatchQueue.main.async {
                self.energyConsumedToday = amount
                self.watchConnector.sendUpdateToWatch(update: ["energyBalance": amount])
            }
        }
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
