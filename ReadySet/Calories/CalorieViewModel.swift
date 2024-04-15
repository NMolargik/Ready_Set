//
//  CalorieViewModel.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/14/24.
//

import Foundation
import SwiftUI
import HealthKit

class CalorieViewModel: ObservableObject {
    @AppStorage("calorieGoal") var calorieGoal: Double = 2000

    @Published var proposedCalorieGoal = 0
    @Published var editingCalorieGoal = false
    
    @Published var caloriesConsumed = 0
    @Published var caloriesConsumedWeek: [Int: Int] = [0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0]
    @Published var caloriesBurned = 0
    @Published var caloriesBurnedWeek: [Int: Int] = [0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0]

    private let healthController = HKController()
    private let healthStore = HKHealthStore()

    init() {
        healthController.requestAuthorization()
        self.readEnergyConsumedToday()
        self.readEnergyBurnedToday()
        self.proposedCalorieGoal = Int(self.calorieGoal)
    }

    func addCalories(calories: Double) {
        DispatchQueue.main.async {
            self.addCaloriesConsumed(calories: calories) {
                withAnimation (.easeInOut) {
                    self.readEnergyConsumedToday()
                }
            }
        }
    }
    
    func readEnergyConsumedToday() {
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
                return
            }

            let calories = Int(sum.doubleValue(for: HKUnit.kilocalorie()))
            self.caloriesConsumed = calories
        }
        healthStore.execute(query)
    }

    func readEnergyConsumedWeek() {
        guard let energyCountType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
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
            quantityType: energyCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startOfWeek,
            intervalComponents: DateComponents(day: 1) // interval to make sure the sum is per 1 day
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
                    let kilocalorie = Int(quantity.doubleValue(for: HKUnit.kilocalorie()))
                    let day = calendar.component(.weekday, from: statistics.startDate)
                    self.caloriesConsumedWeek[day] = kilocalorie
                }
            }
        }

        healthStore.execute(query)
    }
    
    func readEnergyBurnedToday() {
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

            let calories = Int(sum.doubleValue(for: HKUnit.kilocalorie()))
            self.caloriesBurned = calories
        }
        healthStore.execute(query)
    }

    func readEnergyBurnedWeek() {
        guard let energyCountType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
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
            quantityType: energyCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startOfWeek,
            intervalComponents: DateComponents(day: 1) // interval to make sure the sum is per 1 day
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
                    let kilocalorie = Int(quantity.doubleValue(for: HKUnit.kilocalorie()))
                    let day = calendar.component(.weekday, from: statistics.startDate)
                    self.caloriesBurnedWeek[day] = kilocalorie
                }
            }
        }

        healthStore.execute(query)
    }
    
    func addCaloriesConsumed(calories: Double, completion: @escaping () -> Void) {
        let calorieType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        let calorieSample = HKQuantitySample(type: calorieType, quantity: HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories), start: Date(), end: Date())
        self.healthStore.save(calorieSample, withCompletion: { (success, error) -> Void in
            if error != nil {
                print("HealthKit - Error - \(String(describing: error))")
            }

            if success {
                print("HealthKit - Success - Calories successfully saved in HealthKit")


            } else {
                print("HealthKit - Error - Energy consumed unhandled case!")
            }
            
            self.readEnergyConsumedToday()
            completion()

        })
    }

    func saveCalorieGoal() {
        self.calorieGoal = Double(self.proposedCalorieGoal)
        self.editingCalorieGoal = false
    }
}
