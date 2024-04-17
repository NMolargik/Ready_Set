//
//  HealthBaseController.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import Foundation
import HealthKit

struct HealthBaseController {
    var healthStore = HKHealthStore()
    
    func requestAuthorization() {
        let toReads = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        ])
    
        let toShares = Set([
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ])

        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit - Error - Health Data Not Available")
            return
        }

        healthStore.requestAuthorization(toShare: toShares, read: toReads) {
            success, error in
            if success {
                print("HealthKit Approved")
            } else {
                print("HealthKit - Error - \(String(describing: error))")
            }
        }
    }
}
