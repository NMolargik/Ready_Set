//
//  MainWatchViewModel.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import Foundation
import SwiftUI
import HealthKit

class MainWatchViewModel: ObservableObject, HKHelper {
    @AppStorage("watchOnboardingComplete") var watchOnboardingComplete = false
    
    @Published var selectedTab: Int = 0
    @Published var appState: String = "inoperable"
    @Published var useMetric: Bool = false
    @Published var stepGoal: Double = 1000
    @Published var waterGoal: Double = 64
    @Published var energyGoal: Double = 2000
    @Published var stepsTakenToday = 0
    @Published var waterBalance = 0
    @Published var energyBalance = 0
    @Published var progress : Double =  0
    
    @State var healthStore: HKHealthStore?
    
    func getInitialValues(connector: PhoneConnector) {
        connector.requestInitialsFromPhone { response in
            DispatchQueue.main.async {
                self.processPhoneUpdate(update: response)
                print("Initial values retrieved and stored!")
                self.updateProgress()
            }
        }
    }
    
    func readStepCountToday() {
        hkQuery(type: stepCount, unit: HKUnit.count(), failed: "Failed to read step count") { amount in
            DispatchQueue.main.async {
                self.stepsTakenToday = amount
            }
        }
    }
    
    func updateProgress() {
        withAnimation {
            switch (selectedTab) {
            case 0:
                self.progress = Double(stepsTakenToday / Int(stepGoal) * 100)
            case 1:
                self.progress = Double(waterBalance / Int(waterGoal) * 100)
            default:
                self.progress = Double(energyBalance / Int(energyGoal) * 100)
            }
        }
    }
    
    func respondToPhoneUpdate(update: [String : Any]) {
        DispatchQueue.main.async {
            self.processPhoneUpdate(update: update)
            print("Responded to a phone update")
            self.updateProgress()
        }
    }
    
    private func processPhoneUpdate(update: [String : Any]) {
        if let appState = update["appState"] as? String {
            self.appState = appState
        } else {
            self.appState = "inoperable"
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
        
        if let waterBalance = update["waterBalance"] as? Int {
            self.waterBalance = waterBalance
        }
        
        if let energyBalance = update["energyBalance"] as? Int {
            self.energyBalance = energyBalance
        }
    }
}


