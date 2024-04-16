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
    @Published var healthStore = HKHealthStore()
    
    let exerciseSetRepo = ExerciseSetRepo()
    
    init() {
        exerciseSetMaster = exerciseSetRepo.loadAll()
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
            DispatchQueue.main.async {
                self.stepsToday = steps
            }
        }
        healthStore.execute(query)
    }
}
