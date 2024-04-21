//
//  WaterViewModel.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import SwiftUI
import HealthKit
import Foundation

class WaterViewModel: ObservableObject, HKHelper {
    @AppStorage("useMetric") var useMetric: Bool = false
    @AppStorage("waterGoal") var waterGoal: Double = 64
    
    @Published var proposedWaterGoal = 64
    @Published var editingWaterGoal = false
    @Published var waterConsumedToday: Int = 0
    @Published var waterConsumedWeek: [Date: Int] = [:]
    @Published var healthStore: HKHealthStore?
    
    init() {
        self.proposedWaterGoal = Int(self.waterGoal)
        self.readInitial()
    }

    func readInitial() {
        self.readWaterConsumedToday()
        self.readWaterConsumedWeek()
    }
    
    func addWater(waterToAdd: Double) {
        DispatchQueue.main.async {
            self.addWaterConsumed(waterAmount: waterToAdd) {
                withAnimation (.easeInOut) {
                    self.readWaterConsumedToday()
                    self.readWaterConsumedWeek()
                    print(self.waterConsumedWeek.description)
                }
            }
        }
    }
    
    private func readWaterConsumedToday() {
        let unit = self.useMetric ? HKUnit.literUnit(with: .milli) : HKUnit.fluidOunceUS()
        hkQuery(type: waterConsumed, failed: "Failed to read water gallons today", unit: unit) { amount in
            DispatchQueue.main.async {
                self.waterConsumedToday = amount
            }
        }
    }

    private func readWaterConsumedWeek() {
        let endOfWeek = Date().endOfDay
        let startOfWeek = endOfWeek.addingDays(-6).startOfDay

        hkColQuery(type: waterConsumed, anchor: startOfWeek) { _, result, error in
            guard let result = result else {
                if let error = error {
                    print("HealthKit - Error - An error occurred while retrieving water gallons for the week: \(error.localizedDescription)")
                }
                return
            }

            result.enumerateStatistics(from: startOfWeek, to: endOfWeek) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let amount = Int(quantity.doubleValue(for: self.useMetric ? HKUnit.literUnit(with: .milli) : HKUnit.fluidOunceUS()))

                    let day = statistics.startDate
                    DispatchQueue.main.async {
                        self.waterConsumedWeek[day] = amount
                        print("Water amount for \(day): \(amount)")
                    }
                } else {
                    let day = statistics.startDate
                    if day < endOfWeek {
                        DispatchQueue.main.async {
                            self.waterConsumedWeek[day] = 0
                        }
                    }
                }
            }
        }
    }

    private func addWaterConsumed(waterAmount: Double, completion: @escaping () -> Void) {
        let waterSample = HKQuantitySample(type: waterConsumed, quantity: HKQuantity(unit: self.useMetric ? HKUnit.literUnit(with: .milli) : HKUnit.fluidOunceUS(), doubleValue: waterAmount), start: Date(), end: Date())
        
        healthStore?.save(waterSample, withCompletion: { (success, error) -> Void in

            if error != nil {
                print("HealthKit - Error - \(String(describing: error))")
            }
            
            if success {
                print("HealthKit - Success - Water successfully saved in HealthKit")

            } else {
                print("HealthKit - Error - Water Consumed Unhandled case!")
            }
            
            self.readWaterConsumedToday()
            completion()
        })
    }
    
    func saveWaterGoal() {
        self.waterGoal = Double(self.proposedWaterGoal)
        self.editingWaterGoal = false
    }
}
