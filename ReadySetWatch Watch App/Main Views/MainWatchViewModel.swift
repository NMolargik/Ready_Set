//
//  MainWatchViewModel.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import Foundation
import SwiftUI
import HealthKit

class MainWatchViewModel: ObservableObject {
    @AppStorage("watchOnboardingComplete") var watchOnboardingComplete = false
    
    @Published var selectedTab: Int = 0
    @Published var appState: String = "inoperable"
    @Published var useMetric: Bool = false
    @Published var stepGoal: Double = 1000
    @Published var waterGoal: Double = 64
    @Published var energyGoal: Double = 2000
    @Published var stepBalance: Int = 0
    @Published var waterBalance: Int = 0
    @Published var energyBalance: Int = 0
    
    func getInitialValues(connector: PhoneConnector) {
        connector.requestInitialsFromPhone { response in
            self.processPhoneUpdate(update: response)
        }
    }
    
    func processPhoneUpdate(update: [String : Any]) {
        DispatchQueue.main.async {
            if let appState = update["appState"] as? String {
                self.appState = appState
            } else {
                self.appState = "background"
            }
            
            if let useMetric = update["useMetric"] as? Bool {
                self.useMetric = useMetric
            }
            
            if let stepGoal = update["stepGoal"] as? Double {
                self.stepGoal = Double(stepGoal)
            }
            
            if let waterGoal = update["waterGoal"] as? Double {
                self.waterGoal = Double(waterGoal)
            }
            
            if let energyGoal = update["energyGoal"] as? Double {
                self.energyGoal = Double(energyGoal)
            }
            
            if let stepBalance = update["stepBalance"] as? Int {
                print(stepBalance)
                self.stepBalance = stepBalance
            }
            
            if let waterBalance = update["waterBalance"] as? Int {
                print(waterBalance)
                self.waterBalance = waterBalance
            }
            
            if let energyBalance = update["energyBalance"] as? Int {
                print(energyBalance)
                self.energyBalance = energyBalance
            }
        }
    }
}


