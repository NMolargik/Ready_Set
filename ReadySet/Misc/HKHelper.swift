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

    func hkQuery(type: HKQuantityType, callback: @escaping (HKStatisticsQuery, HKStatistics?, (any Error)?) -> Void) {
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: todayPredicate, options: .cumulativeSum, completionHandler: callback)
        healthStore?.execute(query)
    }
}
