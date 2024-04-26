//
//  WatchConnector.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/25/24.
//

import Foundation
import WatchConnectivity
import SwiftUI

class WatchConnector: NSObject, WCSessionDelegate, ObservableObject {
    @AppStorage("appState") var appState: String = "splash"
    @AppStorage("useMetric") var useMetric: Bool = false
    @AppStorage("stepGoal") var stepGoal: Double = 1000
    @AppStorage("waterGoal") var waterGoal: Double = 64
    @AppStorage("energyGoal") var energyGoal: Double = 2000
    
    var requestWaterConsumptionBalance: (() -> Int)
    var requestEnergyConsumptionBalance: (() -> Int)
    var addConsumption: ((EntryType, Int) -> Void)
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        self.requestWaterConsumptionBalance = { 0 }
        self.requestEnergyConsumptionBalance = { 0 }
        self.addConsumption = { _, _ in }
        
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        var response : [String : Any] = ["complete" : true]
        response["appState"] = self.appState
        
        if let _ = message["giveUseMetric"] as? Bool {
            response["useMetric"] = self.useMetric
        }
        
        if let _ = message["giveStepGoal"] as? Bool {
            response["stepGoal"] = self.stepGoal
        }
        
        if let _ = message["giveWaterGoal"] as? Bool {
            response["waterGoal"] = self.waterGoal
        }
        
        if let _ = message["giveEnergyGoal"] as? Bool {
            response["energyGoal"] = self.energyGoal
        }
        
        if let _ = message["giveWaterBalance"] as? Bool {
            response["waterBalance"] = self.requestWaterConsumptionBalance
        }
        
        if let _ = message["giveEnergyBalance"] as? Bool {
            response["energyBalance"] = self.requestEnergyConsumptionBalance
        }
        
        if let waterIntake = message["newWaterIntake"] as? Int {
            receiveNewWaterIntakeFromWatch(intake: waterIntake)
            
            let newBalance = self.requestWaterConsumptionBalance
            response["waterBalance"] = newBalance
        }
        
        if let energyIntake = message["newEnergyIntake"] as? Int {
            receiveNewEnergyIntakeFromWatch(intake: energyIntake)
            
            let newBalance = self.requestEnergyConsumptionBalance
            response["energyBalance"] = newBalance
        }
        
        replyHandler(response)
    }
    
    func sendUpdateToWatch(update: [String : Any]) {
        if session.isReachable {
            var formattedUpdate = update
            formattedUpdate["appState"] = "running"
            session.sendMessage(formattedUpdate) { _ in }
        } else {
            print("Session is not reachable for watch update")
        }
    }
    
    private func receiveNewWaterIntakeFromWatch(intake: Int) {
        DispatchQueue.main.async {
            self.addConsumption(EntryType.water, intake)
        }
    }
    
    private func receiveNewEnergyIntakeFromWatch(intake: Int) {
        DispatchQueue.main.async {
            self.addConsumption(EntryType.energy, intake)
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if (activationState == .activated) {
            print("Connected to a watch")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session with watch went inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Session with watch was deactivated")
    }
}
