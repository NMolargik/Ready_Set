//
//  WaterViewModel.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import Foundation
import SwiftUI

class WaterViewModel: ObservableObject {
    @AppStorage("waterGoal") var waterGoal: Int = 16
    
    @Published var waterConsumed = 0
    @Published var waterHistory = [Int]()
    
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
    }

    func setWaterGoal(waterOunces: Int) {
        self.waterGoal = waterOunces
    }
}
