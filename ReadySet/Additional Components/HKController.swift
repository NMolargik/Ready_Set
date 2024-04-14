//
//  HKController.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/14/24.
//

import HealthKit
import Foundation

class HKController {
    private let healthStore = HKHealthStore()

    var weightToday: Int = 0
    var stepCountToday: Int = 0
    var stepCountWeek: [Int: Int] = [0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0]
    var waterConsumedToday: Int = 0
    var waterConsumedWeek: [Int: Int] = [0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0]
    var energyConsumedToday: Int = 0
    var energyConsumedWeek: [Int: Int] = [0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0]

    func requestAuthorization() {
        let toReads = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        ])

        let toShares = Set([
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
            HKObjectType.workoutType()
        ])

        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit - Error - Health Data Not Available")
            return
        }

        healthStore.requestAuthorization(toShare: toShares, read: toReads) {
            success, error in
            if success {
                self.fetchAllData()
            } else {
                print("HealthKit - Error - \(String(describing: error))")
            }
        }
    }

    func fetchAllData() {
        readStepCountToday()
        readStepCountWeek()
        readWaterConsumedToday()
        readWaterConsumedWeek()
        readEnergyConsumedToday()
        readEnergyConsumedWeek()
        readWeightMonth { _ in }
    }
    func readStepCountToday() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
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
            quantityType: stepCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) {
            _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                return
            }

            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            self.stepCountToday = steps
        }
        healthStore.execute(query)
    }

    func readStepCountWeek() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
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
            quantityType: stepCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum, // fetch the sum of steps for each day
            anchorDate: startOfWeek,
            intervalComponents: DateComponents(day: 1) // interval to make sure the sum is per 1 day
        )

        query.initialResultsHandler = { _, result, error in
            guard let result = result else {
                if let error = error {
                    print("HealthKit - Error - An error occurred while retrieving step count for the week: \(error.localizedDescription)")
                }
                return
            }

            result.enumerateStatistics(from: startOfWeek, to: endOfWeek) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let steps = Int(quantity.doubleValue(for: HKUnit.count()))
                    let day = calendar.component(.weekday, from: statistics.startDate)
                    self.stepCountWeek[day] = steps
                }
            }
        }

        healthStore.execute(query)
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

    func addWaterConsumed(ounces: Double, completion: (Bool) -> Void) {
        let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)!
        let waterSample = HKQuantitySample(type: waterType, quantity: HKQuantity(unit: HKUnit.fluidOunceUS(), doubleValue: ounces), start: Date(), end: Date())
        healthStore.save(waterSample, withCompletion: { (success, error) -> Void in

            if error != nil {
                // something happened
                print("HealthKit - Error - \(String(describing: error))")
                self.readWaterConsumedToday()
            }

            if success {
                print("HealthKit - Success - Steps successfully saved in HealthKit")
                self.readWaterConsumedToday()

            } else {
                print("HealthKit - Error - Water Consumed Unhandled case!")
                self.readWaterConsumedToday()
            }
        })

        completion(true)
    }

    func readWeightMonth(completion: @escaping (Int) -> Void) {
        guard let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else {
            return
        }
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate!,
            end: now,
            options: .strictStartDate
        )

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: weightType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { _, results, _ in
            guard let samples = results as? [HKQuantitySample], let firstSample = samples.first else {
                print("HealthKit - Error - No weight samples found.")
                return
            }

            // Retrieve the total calories burned for today
            let pounds = firstSample.quantity.doubleValue(for: HKUnit.pound())
            self.weightToday = Int(pounds)
        }

        healthStore.execute(query)
        completion(self.weightToday)

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
            self.energyConsumedToday = calories
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
                    let ounces = Int(quantity.doubleValue(for: HKUnit.kilocalorie()))
                    let day = calendar.component(.weekday, from: statistics.startDate)
                    self.energyConsumedWeek[day] = ounces
                }
            }
        }

        healthStore.execute(query)
    }

    func addWeightToday(pounds: Double) {
        let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
        let weightSample = HKQuantitySample(type: weightType, quantity: HKQuantity(unit: HKUnit.pound(), doubleValue: pounds), start: Date(), end: Date())
        healthStore.save(weightSample, withCompletion: { (success, error) -> Void in
            if error != nil {
                print("HealthKit - Error - \(String(describing: error))")
                return
            }

            if success {
                print("HealthKit - Success - Weight successfully saved in HealthKit")
                return
            } else {
                print("HealthKit - Error - Weight unhandled case!")
            }
        })

        self.readWeightMonth { _ in }
    }

    func recordWorkout(secondsSpent: Int) {
        let finish = Date()
        let start =  finish.addingTimeInterval(-Double(secondsSpent))
        let workout = HKWorkout(activityType: .coreTraining, start: start, end: finish)
        healthStore.save(workout) { (success: Bool, _: Error?) -> Void in
            if success {
                print("Workout - Success - Saved to HealthKit")
            } else {
                print("Workout - Error - Failed to save to HealthKit")
            }
        }
    }

    func addCalories(calories: Double) {
        let calorieType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        let calorieSample = HKQuantitySample(type: calorieType, quantity: HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories), start: Date(), end: Date())
        self.healthStore.save(calorieSample, withCompletion: { (success, error) -> Void in
            if error != nil {
                print("HealthKit - Error - \(String(describing: error))")
                self.readEnergyConsumedToday()
            }

            if success {
                print("HealthKit - Success - Calories successfully saved in HealthKit")
                self.readEnergyConsumedToday()
                return

            } else {
                print("HealthKit - Error - Energy consumed unhandled case!")
                self.readEnergyConsumedToday()
                return

            }

        })
    }
}
