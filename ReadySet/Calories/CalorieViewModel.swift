//
//  CalorieViewModel.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/14/24.
//

import Foundation
import SwiftUI

class CalorieViewModel: ObservableObject {
    @AppStorage("calorieGoal") var calorieGoal: Int = 2000

    @Published var caloriesConsumed = 0
    @Published var calorieHistory = [Int]()
    @Published var caloriesBurned = 0
    @Published var burnedHistory = [Int]()

    let healthController = HKController()

    init() {
        healthController.requestAuthorization()
        self.getCaloriesConsumedTodayFromHK()
    }

    func addCalories(calories: Double) {
        self.healthController.addCalories(calories: calories)
        self.getCaloriesConsumedTodayFromHK()
    }

    func getCaloriesConsumedTodayFromHK() {
        self.healthController.readEnergyConsumedToday()
        caloriesConsumed = self.healthController.energyConsumedToday
    }

    func getCalorieWeekFromHK() {
        self.healthController.readEnergyConsumedWeek()
    }

    func getCaloriesBurnedTodayFromHK() {
        self.healthController.readEnergyBurnedToday()
        caloriesConsumed = self.healthController.energyBurnedToday
    }

    func getCaloriesBurnedWeekFromHK() {
        self.healthController.readEnergyBurnedWeek()
    }

    func setCalorieGoal(calories: Int) {
        self.calorieGoal = calories
    }
}
