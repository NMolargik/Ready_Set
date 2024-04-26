//
//  PhoneConnector.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import Foundation
import WatchConnectivity
import SwiftUI

class PhoneConnector: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    
    var respondToPhoneUpdate: (([String : Any]) -> Void)
    
    init(session: WCSession = .default) {
        self.session = session
        self.respondToPhoneUpdate = { _ in }
        
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        let update = self.buildResponseOutput(response: message)
        self.respondToPhoneUpdate(update)
    }
    
    func requestInitialsFromPhone(completion: @escaping ([String : Any]) -> Void) {
        if session.isReachable {
            let payload: [String : Any] = [
                "giveAppState" : true,
                "giveUseMetric" : true,
                "giveStepGoal" : true,
                "giveWaterGoal" : true,
                "giveEnergyGoal" : true,
                "giveWaterBalance" : true,
                "giveEnergyBalance" : true
            ]
            
            session.sendMessage(payload) { response in
                let output = self.buildResponseOutput(response: response)
                completion(output)
            }
        }
    }
    
    func requestValuesFromPhone(values: [String], completion: @escaping ([String : Any]) -> Void) {
        var payload: [String : Any] = [:]
        
        for value in values {
            payload[value] = true
        }
        
        if session.isReachable {
            session.sendMessage(payload) { response in
                let output = self.buildResponseOutput(response: response)
                completion(output)
            }
        } else {
            let output = self.buildResponseOutput(response: ["appState" : "inoperable"])
            completion(output)
        }
    }
    
    func sendNewIntakeToPhone(intake: Int, entryType: EntryType, completion: @escaping (Bool) -> Void) {
        if session.isReachable {
            let payload: [String : Any] = [(entryType == .water ? "waterIntake" : "energyIntake") : intake]
            
            session.sendMessage(payload, replyHandler: { response in
                DispatchQueue.main.async {
                    if let success = response["complete"] as? Bool {
                        completion(success)
                    } else {
                        completion(false)
                    }
                }
            }, errorHandler: { error in
                DispatchQueue.main.async {
                    print("Error sending message: \(error.localizedDescription)")
                    completion(false)
                }
            })
        } else {
            DispatchQueue.main.async {
                print("Session is not reachable for intake report")
                completion(false)
            }
        }
    }
    
    func buildResponseOutput(response: [String : Any]) -> [String : Any] {
        var output : [String : Any] = [:]
        
        if let appState = response["appState"] as? String {
            output["appState"] = appState
        }
        
        if let useMetric = response["useMetric"] as? Bool {
            output["useMetric"] = useMetric
        }
        
        if let stepGoal = response["stepGoal"] as? Double {
            output["stepGoal"] = stepGoal
        }
        
        if let waterGoal = response["waterGoal"] as? Double {
            output["waterGoal"] = waterGoal
        }
        
        if let energyGoal = response["energyGoal"] as? Double {
            output["energyGoal"] = energyGoal
        }
        
        if let waterBalance = response["waterBalance"] as? Int {
            output["waterBalance"] = waterBalance
        }
        
        if let energyBalance = response["energyBalance"] as? Int {
            output["energyBalance"] = energyBalance
        }
        
        return output
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        
        if (activationState == .activated) {
            print("Phone Connected")
        }
    }
}

