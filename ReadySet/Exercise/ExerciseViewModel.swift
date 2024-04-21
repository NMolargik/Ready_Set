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
        hkQuery(type: stepCount, failed: "Failed to read step count", unit: HKUnit.count()) { amount in
            DispatchQueue.main.async {
                self.stepsToday = amount
            }
        }
    }
    
    private func readStepCountWeek() {
        let endOfWeek = Date().endOfDay
        let startOfWeek = endOfWeek.addingDays(-6).startOfDay

        hkColQuery(type: stepCount, anchor: startOfWeek) { _, result, error in
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
