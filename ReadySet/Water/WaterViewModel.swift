//
//  WaterViewModel.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import SwiftUI
import HealthKit
import Foundation

class WaterViewModel: ObservableObject {
    @AppStorage("useMetric") var useMetric: Bool = false
    @AppStorage("waterGoal") var waterGoal: Double = 64
    
    @Published var proposedWaterGoal = 64
    @Published var editingWaterGoal = false
    @Published var waterConsumedToday: Int = 0
    @Published var waterConsumedWeek: [Date: Int] = [:]
    @Published var healthStore: HKHealthStore?
    
    init() {
        self.proposedWaterGoal = Int(self.waterGoal)
        self.readInitial()
    }

    func readInitial() {
        self.readWaterConsumedToday()
        self.readWaterConsumedWeek()
    }
    
    func addWater(waterToAdd: Double) {
        DispatchQueue.main.async {
            self.addWaterConsumed(waterAmount: waterToAdd) {
                withAnimation (.easeInOut) {
                    self.readWaterConsumedToday()
                    self.readWaterConsumedWeek()
                    print(self.waterConsumedWeek.description)
                }
            }
        }
    }
    
    private func readWaterConsumedToday() {
        guard let waterCountType = HKQuantityType.quantityType(forIdentifier: .dietaryWater) else {
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
            quantityType: waterCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) {
            _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("HealthKit - Error - Failed to read water gallons today: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                DispatchQueue.main.async {
                    self.waterConsumedToday = 0
                }
                return
            }

            let amount = Int(sum.doubleValue(for: self.useMetric ? HKUnit.literUnit(with: .milli) : HKUnit.fluidOunceUS()))
            
            DispatchQueue.main.async {
                self.waterConsumedToday = amount
            }
        }
        healthStore?.execute(query)
    }

    private func readWaterConsumedWeek() {
        guard let waterCountType = HKQuantityType.quantityType(forIdentifier: .dietaryWater) else {
            return
        }
        let calendar = Calendar.current
        guard let endOfWeek = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: Date())) else {
            print("HealthKit - Error - Failed to calculate start of the week.")
            return
        }

        guard let startOfWeek = calendar.date(byAdding: .day, value: -7, to: endOfWeek) else {
            print("HealthKit - Error - Failed to calculate the end date of the week.")
            return
        }

        let predicate = HKQuery.predicateForSamples(
            withStart: startOfWeek,
            end: endOfWeek,
            options: .strictStartDate
        )

        let query = HKStatisticsCollectionQuery(
            quantityType: waterCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startOfWeek,
            intervalComponents: DateComponents(day: 1)
        )

        query.initialResultsHandler = { _, result, error in
            guard let result = result else {
                if let error = error {
                    print("HealthKit - Error - An error occurred while retrieving water gallons for the week: \(error.localizedDescription)")
                }
                return
            }

            result.enumerateStatistics(from: startOfWeek, to: endOfWeek) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let amount = Int(quantity.doubleValue(for: self.useMetric ? HKUnit.literUnit(with: .milli) : HKUnit.fluidOunceUS()))

                    let day = statistics.startDate
                    DispatchQueue.main.async {
                        self.waterConsumedWeek[day] = amount
                        print("Water amount for \(day): \(amount)")
                    }
                } else {
                    let day = statistics.startDate
                    DispatchQueue.main.async {
                        self.waterConsumedWeek[day] = 0
                    }
                }
            }
        }

        healthStore?.execute(query)
    }

    private func addWaterConsumed(waterAmount: Double, completion: @escaping () -> Void) {
        let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)!
        
        let waterSample = HKQuantitySample(type: waterType, quantity: HKQuantity(unit: self.useMetric ? HKUnit.literUnit(with: .milli) : HKUnit.fluidOunceUS(), doubleValue: waterAmount), start: Date(), end: Date())
        
        healthStore?.save(waterSample, withCompletion: { (success, error) -> Void in

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
    }
}
