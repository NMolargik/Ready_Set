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
            withStart: Date().addingTimeInterval(-6).startOfDay,
            end: Date().endOfDay,
            options: .strictStartDate
        )
    }

    func hkColQuery(type: HKQuantityType, predicate: NSPredicate, anchor: Date, callback: @escaping (HKStatisticsCollectionQuery, HKStatisticsCollection?, (any Error)?) -> Void) {
        let query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchor, intervalComponents: DateComponents(day: 1))
        query.initialResultsHandler = callback
        healthStore?.execute(query)
    }

    func hkQuery(type: HKQuantityType, predicate: NSPredicate, callback: @escaping (HKStatisticsQuery, HKStatistics?, (any Error)?) -> Void) {
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum, completionHandler: callback)
        healthStore?.execute(query)
    }
}
