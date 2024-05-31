//
//  ExerciseViewModel.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import SwiftUI
import HealthKit

class ExerciseViewModel: ObservableObject, HKHelper {
    static let shared = ExerciseViewModel()

    @AppStorage("stepGoal", store: UserDefaults(suiteName: Bundle.main.groupID)) var stepGoal: Double = 1000
    @AppStorage("decreaseHaptics") var decreaseHaptics: Bool = false
    @AppStorage("stepsToday", store: UserDefaults(suiteName: Bundle.main.groupID)) var stepsToday: Int = 0
    @AppStorage("useMetric", store: UserDefaults(suiteName: Bundle.main.groupID)) var useMetric: Bool = false

    @Published var editingStepGoal = false
    @Published var formComplete: Bool = false
    @Published var proposedStepGoal = 1000
    @Published var currentDay: Int = 1
    @Published var stepCountWeek: [Date: Int] = [:]
    @Published var healthStore = HKHealthStore()
    @Published var sortOrder = SortDescriptor(\Exercise.orderIndex)
    @Published var filteredExercises: [Exercise] = []
    @Published var selectedExercise: Exercise = Exercise()
    @Published var selectedSet: String = ""

    @Published var stepSliderValue: Double = 0 {
        didSet {
            if !decreaseHaptics {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
            self.proposedStepGoal = Int(stepSliderValue)
        }
    }

    @Published var editingSets = false {
        didSet {
            if !self.editingSets {
                self.selectedExercise = Exercise()
                self.selectedSet = ""
            }
        }
    }

    let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var watchConnector: WatchConnector = .shared

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
        watchConnector.sendUpdateToWatch(update: ["stepGoal": stepGoal])
    }

    private func readStepCountToday() {
        hkQuery(type: stepCount, unit: HKUnit.count(), failed: "Failed to read step count") { amount in
            DispatchQueue.main.async {
                self.stepsToday = amount
                self.watchConnector.sendUpdateToWatch(update: ["stepBalance": self.stepsToday])
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
