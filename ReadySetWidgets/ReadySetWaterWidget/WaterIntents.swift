//
//  WaterIntents.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 5/18/24.
//

import Foundation
import AppIntents

struct WaterIntent: AppIntent {
    static var title: LocalizedStringResource = "Log Some Water"
    static var description = IntentDescription("Logs your selected increment value of water to Ready, Set")

    func perform() async throws -> some IntentResult & ReturnsValue<Int> {
        let water: WaterViewModel = .shared
        let incrementManager = IncrementValueManager.shared
        let value = incrementManager.getWaterIncrement(useMetric: water.useMetric)
        water.addWater(waterToAdd: value)

        return .result(value: water.waterConsumedTodayObserved)
    }
}

struct SelectWaterIncrementIntent: WidgetConfigurationIntent {
    
    static var title: LocalizedStringResource = "Select your water incrementation value:"
    static var description = IntentDescription("Set your water increment value.")
    
    @Parameter(title: "Increment Value")
    var waterIncrementValue: Double
    
    func perform() async throws -> some IntentResult & ReturnsValue<Bool> {
        let water: WaterViewModel = .shared
        IncrementValueManager.shared.setWaterIncrement(value: waterIncrementValue, useMetric: water.useMetric)
        return .result(value: true)
    }
    
    init() {
        self.waterIncrementValue = IncrementValueManager.shared.getWaterIncrement(useMetric: WaterViewModel.shared.useMetric)
    }
}
