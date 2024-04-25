//
//  MainWatchViewModel.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import Foundation
import SwiftUI

class MainWatchViewModel: ObservableObject {
    @Published var appState: String = "inoperable"
    @Published var useMetric: Bool = false
    @Published var stepGoal: Double = 1000
    @Published var waterGoal: Double = 64
    @Published var energyGoal: Double = 2000
    
    @Published var stepsTakenToday = 0
    @Published var waterBalance = 0
    @Published var energyBalance = 0
    
    func getInitialValues(connector: PhoneConnector) {
        connector.requestInitialsFromPhone { response in
            self.processPhoneUpdate(update: response)
            print("Initial values retrieved and stored!")
        }
    }
    
    func respondToPhoneUpdate(update: [String : Any]) {
        self.processPhoneUpdate(update: update)
        print("Responded to a phone update")
    }
    
    private func processPhoneUpdate(update: [String : Any]) {
        if let appState = update["appState"] as? String {
            self.appState = appState
        }
        
        if let useMetric = update["useMetric"] as? Bool {
            self.useMetric = useMetric
        }
        
        if let stepGoal = update["stepGoal"] as? Int {
            self.stepGoal = Double(stepGoal)
        }
        
        if let waterGoal = update["waterGoal"] as? Int {
            self.waterGoal = Double(waterGoal)
        }
        
        if let energyGoal = update["energyGoal"] as? Int {
            self.energyGoal = Double(energyGoal)
        }
        
        if let waterBalance = update["waterBalance"] as? Int {
            self.waterBalance = waterBalance
        }
        
        if let energyBalance = update["energyBalance"] as? Int {
            self.energyBalance = energyBalance
        }
    }
}


