//
//  Intents.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 5/9/24.
//

import Foundation
import AppIntents

struct WaterIntent: AppIntent {
    static var title: LocalizedStringResource = "Log Some Water"
    
    static var description = IntentDescription("Logs 8oz or 240mL, depending on your chosen units, of water to Ready, Set")
    
    func perform() async throws -> some IntentResult & ReturnsValue {
        let data = DataService.shared
        data.addSomeWater()
        
        
        return .result(value: data.waterConsumedToday)
    }
}

struct EnergyIntent: AppIntent {
    static var title: LocalizedStringResource = "Log Some Energy"
    
    static var description = IntentDescription("Logs 200cal or 800kJ, depending on your chosen units, of energy to Ready, Set")
    
    func perform() async throws -> some IntentResult & ReturnsValue {
        let data = DataService.shared
        data.addSomeEnergy()

        
        return .result(value: data.energyConsumedToday)
    }
}
