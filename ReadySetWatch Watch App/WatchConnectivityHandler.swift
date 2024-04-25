//
//  WatchConnectivityHandler.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/24/24.
//

import Foundation
import WatchConnectivity
import SwiftUI

class WatchConnectivityHandler: NSObject, WCSessionDelegate, ObservableObject {
    @AppStorage("useMetric") var useMetric: Bool = false
    @AppStorage("waterGoal") var waterGoal: Double = 64
    @AppStorage("energyGoal") var energyGoal: Double = 2000
    
    @Published var waterConsumed: Double = 0
    @Published var energyConsumed: Double = 0
    
    static let shared = WatchConnectivityHandler()
    var session: WCSession
    
    override init() {
        self.session = WCSession.default  // Initialize the session first
        super.init()  // Now call super.init()
        
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle activation completion
        if activationState == .activated {
            self.requestCurrentIntake()
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let waterGoal = message["waterGoal"] as? Double {
                print(waterGoal)
                self.waterGoal = waterGoal
            }
            if let energyGoal = message["energyGoal"] as? Double {

                self.energyGoal = energyGoal
            }
            if let waterConsumed = message["waterConsumed"] as? Double {
                self.waterConsumed = waterConsumed
            }
            if let energyConsumed = message["energyConsumed"] as? Double {
                self.energyConsumed = energyConsumed
            }
        }
    }
    
    /// Function to request current consumption values from iOS
    func requestCurrentIntake() {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["request": "currentWaterIntake"], replyHandler: { reply in
                if let currentWaterIntake = reply["currentWaterIntake"] as? Double {
                    DispatchQueue.main.async {
                        print("Watch: CurrentWaterIntake: \(currentWaterIntake)")
                        self.waterConsumed = currentWaterIntake
                    }
                }
            }, errorHandler: { error in
                print("Error requesting current water intake: \(error.localizedDescription)")
            })

            WCSession.default.sendMessage(["request": "currentEnergyIntake"], replyHandler: { reply in
                if let currentEnergyIntake = reply["currentEnergyIntake"] as? Double {
                    DispatchQueue.main.async {
                        print("Watch: CurrentEnergyIntake: \(currentEnergyIntake)")
                        self.energyConsumed = currentEnergyIntake
                    }
                }
            }, errorHandler: { error in
                print("Error requesting current energy intake: \(error.localizedDescription)")
            })
        }
    }
}
