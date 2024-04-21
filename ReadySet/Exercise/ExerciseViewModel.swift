//
//  ExerciseViewModel.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import SwiftUI
import HealthKit

class ExerciseViewModel: ObservableObject, HKHelper {
    @AppStorage("stepGoal") var stepGoal: Double = 1000
    
    @Published var expandedSets = false
    @Published var editingSets = false
    @Published var editingStepGoal = false
    @Published var formComplete: Bool = false
    @Published var proposedStepGoal = 1000
    @Published var stepsToday = 0
    @Published var currentDay: Int = 1
    @Published var stepCountWeek: [Date : Int] = [:]
    @Published var healthStore: HKHealthStore?

    init() {
        self.getCurrentWeekday()
        self.readInitial()
    }
    
    func readInitial() {
        self.getCurrentWeekday()
        self.readStepCountToday()
        self.readStepCountWeek()
    }
    
    func getCurrentWeekday() {
        self.currentDay = Date().weekday
    }
    
    func saveStepGoal() {
        self.stepGoal = Double(self.proposedStepGoal)
        self.editingStepGoal = false
    }
    
    private func readStepCountToday() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }

        hkQuery(type: stepCountType) {
            _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                DispatchQueue.main.async {
                    self.stepsToday = 0
                }
                return
            }
            
            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            DispatchQueue.main.async {
                self.stepsToday = steps
            }
        }
    }
    
    private func readStepCountWeek() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        let endOfWeek = Date().endOfDay
        let startOfWeek = endOfWeek.addingDays(-6).startOfDay

        hkColQuery(type: stepCountType, anchor: startOfWeek) { _, result, error in
            guard let result = result else {
                if let error = error {
                    print("HealthKit - Error - An error occurred while retrieving energy consumed for the week: \(error.localizedDescription)")
                }
                return
            }

            result.enumerateStatistics(from: startOfWeek, to: endOfWeek) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let steps = Int(quantity.doubleValue(for: HKUnit.count()))
                    
                    let day = statistics.startDate
                    DispatchQueue.main.async {
                        self.stepCountWeek[day] = steps
                    }
                } else {
                    let day = statistics.startDate
                    if day < endOfWeek {
                        DispatchQueue.main.async {
                            self.stepCountWeek[day] = 0
                        }
                    }
                }
            }
        }
    }
}
