//
//  ConnectivityHandler.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/24/24.
//

import Foundation
import WatchConnectivity

class ConnectivityHandler: NSObject, WCSessionDelegate {
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

    func startSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    // Handle incoming message
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Update UI or process data as necessary
        if let newGoals = message["goals"] as? [String: Any] {
            // Update goals
        }
    }
    
    // Request water from phone
    func requestWaterIntakeData() {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["request": "waterIntake"], replyHandler: { response in
                if let waterIntake = response["currentWaterIntake"] as? Double {
                    // Update UI with the current water intake
                }
            }, errorHandler: { error in
                print("Error sending message: \(error.localizedDescription)")
            })
        }
    }
    
    // Send water to phone
    func sendWaterIntakeToPhone(_ waterIntake: Double) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["newWaterIntake": waterIntake], replyHandler: nil, errorHandler: { error in
                print("Error sending water intake: \(error.localizedDescription)")
            })
        }
    }
    
    // Request energy intake from phone
    func requestEnergyIntakeFromPhone() {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["request": "energyIntake"], replyHandler: { response in
                if let waterIntake = response["energyIntake"] as? Double {
                    // Update UI with the current water intake
                }
            }, errorHandler: { error in
                print("Error sending message: \(error.localizedDescription)")
            })
        }
    }
    
    // Send energy to phone
    func sendEnergyToPhone(_ energyIntake: Double) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["newEnergyIntake": energyIntake], replyHandler: nil, errorHandler: { error in
                print("Error sending energy intake: \(error.localizedDescription)")
            })
        }
    }
}
