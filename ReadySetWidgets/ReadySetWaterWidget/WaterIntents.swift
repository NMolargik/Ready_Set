//
//  WaterIntents.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 5/18/24.
//

import Foundation
import AppIntents
import SwiftUI

struct WaterIntent: AppIntent {
    static var title: LocalizedStringResource = "Log Some Water"
    static var description = IntentDescription("Logs your selected increment value of water to Ready, Set")

    func perform() async throws -> some IntentResult & ReturnsValue<Int> {
        let waterViewModel: WaterViewModel = .shared
        waterViewModel.addSomeWater()

        return .result(value: waterViewModel.waterConsumedTodayObserved)
    }
}

struct SelectWaterIncrementIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select your water incrementation value:"
    static var description = IntentDescription("Set your water increment value.")
    
    @Parameter(title: "Increment Value")
    var waterIncrementValue: Double
    
    func perform() async throws -> some IntentResult & ReturnsValue<Bool> {
        let dataService: DataService = .shared
        dataService.waterIncrementValue = waterIncrementValue
        return .result(value: true)
    }
    
    init() {
        let waterViewModel: WaterViewModel = .shared
        let dataService: DataService = .shared
        dataService.waterIncrementValue = waterViewModel.waterIncrementValueObserved
        self.waterIncrementValue = dataService.waterIncrementValue
    }
}
