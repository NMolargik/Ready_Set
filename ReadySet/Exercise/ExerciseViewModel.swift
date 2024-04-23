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
        DispatchQueue.main.async {
            self.getCurrentWeekday()
            self.readStepCountToday()
            self.readStepCountWeek()
        }
    }
    
    func getCurrentWeekday() {
        DispatchQueue.main.async {
            self.currentDay = Date().weekday
        }
    }
    
    func saveStepGoal() {
        self.stepGoal = Double(self.proposedStepGoal)
        self.editingStepGoal = false
    }
    
    private func readStepCountToday() {
        DispatchQueue.background(background: {
            self.hkQuery(type: self.stepCount, unit: HKUnit.count(), failed: "Failed to read step count") { amount in
                DispatchQueue.main.async {
                    self.stepsToday = amount
                }
            }
        })
    }
    
    private func readStepCountWeek() {
        let end = Date().endOfDay
        let start = end.addingDays(-6).startOfDay

        DispatchQueue.background(background: {
            self.hkColQuery(type: self.stepCount, start: start, end: end, unit: HKUnit.count(), failed: "Error while reading step count during week") { day, amount in
                DispatchQueue.main.async {
                    self.stepCountWeek[day] = amount
                }
            }
        })
    }
}
