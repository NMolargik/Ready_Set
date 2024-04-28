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
    @Published var watchConnector: WatchConnector?

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
        watchConnector?.sendUpdateToWatch(update: ["stepGoal" : stepGoal])
    }
    
    private func readStepCountToday() {
        hkQuery(type: stepCount, unit: HKUnit.count(), failed: "Failed to read step count") { amount in
            DispatchQueue.main.async {
                self.stepsToday = amount
            }
        }
    }
    
    private func readStepCountWeek() {
        let end = Date().endOfDay
        let start = end.addingDays(-6).startOfDay

        hkColQuery(type: stepCount, start: start, end: end, unit: HKUnit.count(), failed: "Error while reading step count during week") { day, amount in
            DispatchQueue.main.async {
                self.stepCountWeek[day] = amount
            }
        }
    }
}
