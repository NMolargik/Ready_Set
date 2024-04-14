//
//  WaterViewModel.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import Foundation
import SwiftUI

class WaterViewModel: ObservableObject {
    @AppStorage("waterGoal") var waterGoal: Int = 1
    
    @Published var waterConsumed = 0
    @Published var waterHistory = [Int]()
    
    let healthController = HKController()
    
    init() {
        self.getWaterTodayFromHK()
        waterConsumed = healthController.waterConsumedToday
    }
    
    func addWater(waterOunces: Double) {
        self.healthController.addWaterConsumed(ounces: waterOunces)
    }
    
    func getWaterTodayFromHK() {
        self.healthController.readWaterConsumedToday()
    }
    
    func setWaterGoal(waterOunces: Int) {
        self.waterGoal = waterOunces
    }
}
