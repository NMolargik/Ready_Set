//
//  ExerciseViewModel.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import SwiftUI
import HealthKit

@Observable class ExerciseViewModel: HKHelper {
    static let shared = ExerciseViewModel()

    @ObservationIgnored @AppStorage("stepGoal", store: UserDefaults(suiteName: Bundle.main.groupID)) var stepGoal: Double = 1000
    @ObservationIgnored @AppStorage("decreaseHaptics") var decreaseHaptics: Bool = false
    @ObservationIgnored @AppStorage("stepsToday", store: UserDefaults(suiteName: Bundle.main.groupID)) var stepsToday: Int = 0
    @ObservationIgnored @AppStorage("useMetric", store: UserDefaults(suiteName: Bundle.main.groupID)) var useMetric: Bool = false

    var expandedSets = false
    var editingStepGoal = false
    var formComplete: Bool = false
    var proposedStepGoal = 1000
    var currentDay: Int = 1
    var stepCountWeek: [Date: Int] = [:]
    var healthStore = HKHealthStore()
    var sortOrder = SortDescriptor(\Exercise.orderIndex)
    var filteredExercises: [Exercise] = []
    var selectedExercise: Exercise = Exercise()
    var selectedSet: String = ""

    var stepSliderValue: Double = 0 {
        didSet {
            if !decreaseHaptics {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
            self.proposedStepGoal = Int(stepSliderValue)
        }
    }

    var editingSets = false {
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

    func disableScroll() -> Bool {
        return !editingSets && !expandedSets
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
