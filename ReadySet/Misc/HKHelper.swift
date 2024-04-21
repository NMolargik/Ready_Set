//
//  HKHelper.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/21/24.
//

import Foundation
import HealthKit

protocol HKHelper {
    var healthStore: HKHealthStore? { get set }

}

extension HKHelper {
    var energyBurned: HKQuantityType {
        return HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
    }

    var energyConsumed: HKQuantityType {
        return HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
    }

    var waterConsumed: HKQuantityType {
        return HKQuantityType.quantityType(forIdentifier: .dietaryWater)!
    }

    var stepCount: HKQuantityType {
        return HKQuantityType.quantityType(forIdentifier: .stepCount)!
    }

    var todayPredicate: NSPredicate {
        return HKQuery.predicateForSamples(
            withStart: Date().startOfDay,
            end: Date().endOfDay,
            options: .strictStartDate
        )
    }

    var weekPredicate: NSPredicate {
        return HKQuery.predicateForSamples(
            withStart: Date().addingDays(-6).startOfDay,
            end: Date().endOfDay,
            options: .strictStartDate
        )
    }
    
    func hkColQuery(type: HKQuantityType, anchor: Date, callback: @escaping (HKStatisticsCollectionQuery, HKStatisticsCollection?, (any Error)?) -> Void) {
        let query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: weekPredicate, options: .cumulativeSum, anchorDate: anchor, intervalComponents: DateComponents(day: 1))
        query.initialResultsHandler = callback
        healthStore?.execute(query)
    }
    
    func hkQuery(type: HKQuantityType, failed: String, unit: HKUnit, with block: @escaping (Int) -> Void) {
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: todayPredicate) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("HealthKit - Error - \(failed): \(error?.localizedDescription ?? "Unknown Error")")
                block(0)
                return
            }
            let amount = Int(sum.doubleValue(for: unit))
            block(amount)
        }
        healthStore?.execute(query)
    }
}
