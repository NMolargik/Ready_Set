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

    func requestAuthorization() {
        let toReads = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        ])

        let toShares = Set([
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
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


}
