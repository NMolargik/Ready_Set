//
//  EnergyViewModel.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/14/24.
//

import SwiftUI
import HealthKit

class EnergyViewModel: ObservableObject {
    @AppStorage("useMetric") var useMetric: Bool = false
    @AppStorage("energyGoal") var energyGoal: Double = 2000

    @Published var proposedEnergyGoal = 0
    @Published var editingEnergyGoal = false
    @Published var energyConsumedToday: Int = 0
    @Published var energyConsumedWeek: [Date : Int] = [:]
    @Published var energyBurnedToday: Int = 0
    @Published var energyBurnedWeek: [Date : Int] = [:]
    @Published var healthStore: HKHealthStore?
    
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
        DispatchQueue.main.async {
            self.addEnergyConsumed(energy: energy) {
                withAnimation (.easeInOut) {
                    self.readEnergyConsumedToday()
                    self.readEnergyConsumedWeek()
                    self.readEnergyBurnedWeek()
                    self.readEnergyBurnedToday()
                }
            }
        }
    }
    
    private func readEnergyConsumedToday() {
        guard let energyCountType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            return
        }

        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: now,
            options: .strictStartDate
        )

        let query = HKStatisticsQuery(
            quantityType: energyCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) {
            _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("HealthKit - Error - Failed to read energy consumed today: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                DispatchQueue.main.async {
                    self.energyConsumedToday = 0
                }
                return
            }

            let Energy = Int(sum.doubleValue(for: self.useMetric ? HKUnit.jouleUnit(with: .kilo) : HKUnit.kilocalorie()))
            DispatchQueue.main.async {
                self.energyConsumedToday = Energy
            }
        }
        healthStore?.execute(query)
    }

    private func readEnergyConsumedWeek() {
        guard let energyCountType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            return
        }
        let calendar = Calendar.current
        guard let endOfToday = calendar.date(bySetting: .hour, value: 23, of: calendar.startOfDay(for: Date())) else {
            print("HealthKit - Error - Failed to calculate the end date of the week.")
            return
        }

        guard let endOfWeek = calendar.date(bySetting: .minute, value: 59, of: endOfToday) else {
            print("HealthKit - Error - Failed to calculate the end date of the week.")
            return
        }

        guard let startOfWeek = calendar.date(byAdding: .day, value: -6, to: endOfWeek) else {
            print("HealthKit - Error - Failed to calculate the start date of the week.")
            return
        }

        let predicate = HKQuery.predicateForSamples(
            withStart: startOfWeek,
            end: endOfWeek,
            options: .strictStartDate
        )

        let query = HKStatisticsCollectionQuery(
            quantityType: energyCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startOfWeek,
            intervalComponents: DateComponents(day: 1)
        )

        query.initialResultsHandler = { _, result, error in
            guard let result = result else {
                if let error = error {
                    print("HealthKit - Error - An error occurred while retrieving energy consumed for the week: \(error.localizedDescription)")
                }
                return
            }

            result.enumerateStatistics(from: startOfWeek, to: endOfWeek) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let kiloEnergy = Int(quantity.doubleValue(for: self.useMetric ? HKUnit.jouleUnit(with: .kilo) : HKUnit.kilocalorie()))
                    
                    let day = statistics.startDate
                    DispatchQueue.main.async {
                        self.energyConsumedWeek[day] = kiloEnergy
                    }
                }
                else {
                    let day = statistics.startDate
                    if day < endOfWeek {
                        DispatchQueue.main.async {
                            self.energyConsumedWeek[day] = 0
                        }
                    }
                }
            }
        }

        healthStore?.execute(query)
    }
    
    private func readEnergyBurnedToday() {
        guard let energyCountType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return
        }

        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: now,
            options: .strictStartDate
        )

        let query = HKStatisticsQuery(
            quantityType: energyCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) {
            _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("HealthKit - Error - Failed to read energy consumed today: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                return
            }

            let energy = Int(sum.doubleValue(for: self.useMetric ? HKUnit.jouleUnit(with: .kilo) : HKUnit.kilocalorie()))
            DispatchQueue.main.async {
                self.energyBurnedToday = energy
            }
        }
        healthStore?.execute(query)
    }

    private func readEnergyBurnedWeek() {
        guard let energyCountType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return
        }
        let calendar = Calendar.current
        guard let endOfToday = calendar.date(bySetting: .hour, value: 23, of: calendar.startOfDay(for: Date())) else {
            print("HealthKit - Error - Failed to calculate the end date of the week.")
            return
        }

        guard let endOfWeek = calendar.date(bySetting: .minute, value: 59, of: endOfToday) else {
            print("HealthKit - Error - Failed to calculate the end date of the week.")
            return
        }

        guard let startOfWeek = calendar.date(byAdding: .day, value: -6, to: endOfWeek) else {
            print("HealthKit - Error - Failed to calculate the start date of the week.")
            return
        }

        let predicate = HKQuery.predicateForSamples(
            withStart: startOfWeek,
            end: endOfWeek,
            options: .strictStartDate
        )

        let query = HKStatisticsCollectionQuery(
            quantityType: energyCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startOfWeek,
            intervalComponents: DateComponents(day: 1)
        )

        query.initialResultsHandler = { _, result, error in
            guard let result = result else {
                if let error = error {
                    print("HealthKit - Error - An error occurred while retrieving energy consumed for the week: \(error.localizedDescription)")
                }
                return
            }

            result.enumerateStatistics(from: startOfWeek, to: endOfWeek) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let kiloEnergy = Int(quantity.doubleValue(for: self.useMetric ? HKUnit.jouleUnit(with: .kilo) : HKUnit.kilocalorie()))
                    
                    let day = statistics.startDate
                    DispatchQueue.main.async {
                        self.energyBurnedWeek[day] = kiloEnergy
                    }
                } else {
                    let day = statistics.startDate
                    if day < endOfWeek {
                        DispatchQueue.main.async {
                            self.energyBurnedWeek[day] = 0
                        }
                    }
                }
            }
        }

        healthStore?.execute(query)
    }
    
    private func addEnergyConsumed(energy: Double, completion: @escaping () -> Void) {
        let energyType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        let energysample = HKQuantitySample(type: energyType, quantity: HKQuantity(unit: self.useMetric ? HKUnit.jouleUnit(with: .kilo) : HKUnit.kilocalorie(), doubleValue: energy), start: Date(), end: Date())
        self.healthStore?.save(energysample, withCompletion: { (success, error) -> Void in
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
    }
}
