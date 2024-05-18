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
        let energyViewModel: EnergyViewModel = .shared
        energyViewModel.consumeSomeEnergy()

        return .result(value: energyViewModel.energyConsumedTodayObserved)
    }
}

struct SelectEnergyIncrementIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select your energy incrementation value:"
    static var description = IntentDescription("Set your energy increment value.")
    
    @Parameter(title: "Increment Value")
    var energyIncrementValue: Double
    
    func perform() async throws -> some IntentResult & ReturnsValue<Bool> {
        let dataService: DataService = .shared
        dataService.energyIncrementValue = energyIncrementValue
        return .result(value: true)
    }
    
    init() {
        let energyViewModel: EnergyViewModel = .shared
        let dataService: DataService = .shared
        dataService.energyIncrementValue = energyViewModel.energyIncrementValueObserved
        self.energyIncrementValue = dataService.energyIncrementValue
    }
}
