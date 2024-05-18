//
//  EnergyIntents.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 5/18/24.
//

import Foundation
import AppIntents

struct EnergyIntent: AppIntent {
    static var title: LocalizedStringResource = "Log Some Energy"
    static var description = IntentDescription("Logs your selected increment value of energy to Ready, Set")

    func perform() async throws -> some IntentResult & ReturnsValue<Int> {
        let energy: EnergyViewModel = .shared
        let incrementManager = IncrementValueManager.shared
        let value = incrementManager.getEnergyIncrement(useMetric: energy.useMetric)
        energy.addEnergy(energy: value)

        return .result(value: energy.energyConsumedToday)
    }
}

struct SelectEnergyIncrementIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select your energy incrementation value:"
    static var description = IntentDescription("Set your energy increment value.")
    
    @Parameter(title: "Increment Value")
    var energyIncrementValue: Double
    
    func perform() async throws -> some IntentResult & ReturnsValue<Bool> {
        let energy: EnergyViewModel = .shared
        IncrementValueManager.shared.setEnergyIncrement(value: energyIncrementValue, useMetric: energy.useMetric)
        return .result(value: true)
    }

    init(currentIncrementValue: Double) {
        self.energyIncrementValue = currentIncrementValue
    }
    
    init() {}
}
