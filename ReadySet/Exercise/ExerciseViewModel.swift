//
//  ExerciseViewModel.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import Foundation
import SwiftUI
import HealthKit

class ExerciseViewModel: ObservableObject {
    @AppStorage("stepGoal") var stepGoal: Double = 1000
    // Add the repo for getting all sets

    @Published var exerciseSetMaster: [ExerciseSet] = [ExerciseSet]()
    @Published var editingStepGoal = false
    @Published var proposedStepGoal = 1000
    @Published var stepsToday = 0
    @Published var formComplete: Bool = false
    
    private let healthStore = HKHealthStore()
    let exerciseSetRepo = ExerciseSetRepo()
    
    init() {
        exerciseSetMaster = exerciseSetRepo.loadAll()
        self.requestAuthorization()
        self.readInitial()
    }
    
    func requestAuthorization() {
        let toReads = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
        ])

        let toShares = Set([
            HKObjectType.workoutType()
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
        self.readStepCountToday()
    }
    
    func saveStepGoal() {
        self.stepGoal = Double(self.proposedStepGoal)
        self.editingStepGoal = false
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
            self.stepsToday = steps
        }
        healthStore.execute(query)
    }
}
