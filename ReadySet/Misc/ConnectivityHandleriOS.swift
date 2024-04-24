//
//  WatchConnector.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/23/24.
//

import Foundation
import WatchConnectivity
import HealthKit
import SwiftUI

class ConnectivityHandler: NSObject, WCSessionDelegate {
    @AppStorage("useMetric") var useMetric: Bool = false
    @AppStorage("waterGoal") var waterGoal: Double = 64
    @AppStorage("energyGoal") var energyGoal: Double = 2000
    
    static let shared = ConnectivityHandler()
    
    var session: WCSession

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }

    func startSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
/// Send water goal
    func sendWaterGoalToWatch(waterGoal: Double) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["waterGoal": waterGoal], replyHandler: nil, errorHandler: { error in
                print("Error sending water goal to watch: \(error.localizedDescription)")
            })
        }
    }
    
/// Send energy goal
    func sendEnergyGoalToWatch(energyGoal: Double) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["energyGoal": energyGoal], replyHandler: nil, errorHandler: { error in
                print("Error sending energy goal to watch: \(error.localizedDescription)")
            })
        }
    }
    
/// Save new intake to HealthKit
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let waterIntake = message["newWaterIntake"] as? Double {
            saveNewIntake(entryType: .water, intake: waterIntake)
        } else if let energyIntake = message["newEnergyIntake"] as? Double {
            saveNewIntake(entryType: .energy, intake: energyIntake)
        }
    }

    func saveNewIntake(entryType: EntryType, intake: Double) {
        let healthStore = HKHealthStore()
        let date = Date()
        let metricType = (entryType == .water) ? HKObjectType.quantityType(forIdentifier: .dietaryWater)! : HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        
        let quantity = {
            if (entryType == .water) {
                return HKQuantity(unit: self.useMetric ? .literUnit(with: .milli) : .fluidOunceUS(), doubleValue: intake)
            } else {
                return HKQuantity(unit: self.useMetric ? .jouleUnit(with: .kilo) : .kilocalorie(), doubleValue: intake)
            }
        }
        
        let sample = HKQuantitySample(type: metricType, quantity: quantity(), start: date, end: date)

        healthStore.save(sample) { success, error in
            if let error = error {
                print("Error saving \(entryType) intake to HealthKit: \(error.localizedDescription)")
            }
        }
    }
    
/// Send current consumption from iOS to watchOS
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if message["request"] as? String == "currentWaterIntake" {
            fetchCurrentWaterIntake { currentWaterIntake in
                replyHandler(["currentWaterIntake": currentWaterIntake])
            }
        } else if message["request"] as? String == "currentEnergyIntake" {
            fetchCurrentEnergyIntake { currentEnergyIntake in
                replyHandler(["currentEnergyIntake": currentEnergyIntake])
            }
        }
    }
    
    func fetchCurrentWaterIntake(completion: @escaping (Double) -> Void) {
        let healthStore = HKHealthStore()
        let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: waterType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0)
                return
            }
            let waterIntake = sum.doubleValue(for: self.useMetric ? .literUnit(with: .milli) : .fluidOunceUS())
            completion(waterIntake)
        }
        healthStore.execute(query)
    }
    
    
    func fetchCurrentEnergyIntake(completion: @escaping (Double) -> Void) {
        let healthStore = HKHealthStore()
        let waterType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: waterType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0)
                return
            }
            let currentEnergyIntake = sum.doubleValue(for: self.useMetric ? .jouleUnit(with: .kilo) : .kilocalorie())
            completion(currentEnergyIntake)
        }
        healthStore.execute(query)
    }
    
/// Immediately send consumption values to watch
    func sendWaterConsumedToWatch(_ waterConsumed: Double) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["waterConsumed": waterConsumed], replyHandler: nil, errorHandler: { error in
                print("Error sending water consumed to watch: \(error.localizedDescription)")
            })
        }
    }
    
    func sendEnergyConsumedToWatch(_ energyConsumed: Double) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["energyConsumed": energyConsumed], replyHandler: nil, errorHandler: { error in
                print("Error sending energy consumed to watch: \(error.localizedDescription)")
            })
        }
    }
}
