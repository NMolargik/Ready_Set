//
//  WaterViewModel.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import Foundation
import SwiftUI

class WaterViewModel: ObservableObject {
    @AppStorage("waterGoal") var waterGoal: Double = 8
    
    @Published var waterConsumed = 0
    @Published var waterHistory: [Int: Int] = [:]
    @Published var proposedWaterGoal = 8
    @Published var editingWaterGoal = false
    
    let healthController = HKController()
    
    init() {
        healthController.requestAuthorization()
        self.getWaterTodayFromHK()
    }
    
    func addWater(waterOunces: Double) {
        self.healthController.addWaterConsumed(ounces: waterOunces)
        self.getWaterTodayFromHK()
    }
    
    func getWaterTodayFromHK() {
        self.healthController.readWaterConsumedToday()
        waterConsumed = self.healthController.waterConsumedToday
    }

    func getWaterWeekFromHK() {
        self.healthController.readWaterConsumedWeek()
        self.waterHistory = self.healthController.waterConsumedWeek
    }
    
    func saveWaterGoal() {
        self.waterGoal = Double(self.proposedWaterGoal)
    }
}
