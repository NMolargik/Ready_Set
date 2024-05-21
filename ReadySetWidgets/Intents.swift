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

    func perform() async throws -> some IntentResult & ReturnsValue<Int> {
        let water: WaterViewModel = .shared
        let value = water.useMetric ? 240 : 8
        water.addWater(waterToAdd: Double(value) as Double)
        water.readWaterConsumedToday()

        return .result(value: water.waterConsumedToday)
    }
}

struct EnergyIntent: AppIntent {
    static var title: LocalizedStringResource = "Log Some Energy"

    static var description = IntentDescription("Logs 200cal or 800kJ, depending on your chosen units, of energy to Ready, Set")

    func perform() async throws -> some IntentResult & ReturnsValue<Int> {
        let energy: EnergyViewModel = .shared
        let value = energy.useMetric ? 800 : 200
        energy.addEnergy(energy: Double(value))
        energy.readEnergyConsumedToday()

        return .result(value: energy.energyConsumedToday)
    }
}
