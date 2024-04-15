//
//  WaterViewModel.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import Foundation
import SwiftUI
import HealthKit

class WaterViewModel: ObservableObject {
    @AppStorage("waterGoal") var waterGoal: Double = 8
    
    @Published var proposedWaterGoal = 8
    @Published var editingWaterGoal = false
    @Published var waterConsumedToday: Int = 0
    @Published var waterConsumedWeek: [Int: Int] = [0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0]

    private let healthStore = HKHealthStore()
    
    init() {
        self.requestAuthorization()
        self.readInitial()
        self.proposedWaterGoal = Int(self.waterGoal)
    }
    
    func requestAuthorization() {
        let toReads = Set([
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
        ])

        let toShares = Set([
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
        ])

        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit - Error - Health Data Not Available")
            return
        }

        healthStore.requestAuthorization(toShare: toShares, read: toReads) {
            success, error in
            if success {
                self.readInitial()
            } else {
                print("HealthKit - Error - \(String(describing: error))")
            }
        }
    }
    
    func readInitial() {
        self.readWaterConsumedToday()
        self.readWaterConsumedWeek()
    }
    
    func addWater(waterOunces: Double) {
        DispatchQueue.main.async {
            self.addWaterConsumed(ounces: waterOunces) {
                withAnimation (.easeInOut) {
                    self.readWaterConsumedToday()
                }
            }
        }
    }
    
    func readWaterConsumedToday() {
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
                return
            }

            let ounces = Int(sum.doubleValue(for: HKUnit.fluidOunceUS()))
            self.waterConsumedToday = ounces
        }
        healthStore.execute(query)
    }

    func readWaterConsumedWeek() {
        guard let waterCountType = HKQuantityType.quantityType(forIdentifier: .dietaryWater) else {
            return
        }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            print("HealthKit - Error - Failed to calculate the start date of the week.")
            return
        }

        guard let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) else {
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
            intervalComponents: DateComponents(day: 1) // interval to make sure the sum is per 1 day
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
                    let ounces = Int(quantity.doubleValue(for: HKUnit.fluidOunceUS()))
                    let day = calendar.component(.weekday, from: statistics.startDate)
                    self.waterConsumedWeek[day] = ounces
                }
            }
        }

        healthStore.execute(query)
    }

    func addWaterConsumed(ounces: Double, completion: @escaping () -> Void) {
        let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)!
        let waterSample = HKQuantitySample(type: waterType, quantity: HKQuantity(unit: HKUnit.fluidOunceUS(), doubleValue: ounces), start: Date(), end: Date())
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
    }
}
