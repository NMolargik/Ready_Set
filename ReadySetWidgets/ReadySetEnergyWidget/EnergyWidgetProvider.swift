//
//  EnergyWidgetProvider.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 4/28/24.
//

import Foundation
import WidgetKit

struct EnergyWidgetProvider: AppIntentTimelineProvider {
    typealias Entry = SimpleEntry
    typealias Intent = SelectEnergyIncrementIntent
    
    var energy: EnergyViewModel = .shared
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), consumption: energy.energyConsumedToday, goal: energy.energyGoal)
    }
    
    func snapshot(for configuration: SelectEnergyIncrementIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), consumption: energy.energyConsumedToday, goal: energy.energyGoal)
    }
    
    func timeline(for configuration: SelectEnergyIncrementIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let currentDate = Date()
        let startOfDay = Calendar.current.startOfDay(for: currentDate)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let entry = SimpleEntry(date: startOfDay, consumption: energy.energyConsumedToday, goal: energy.energyGoal)
        let timeline = Timeline(entries: [entry], policy: .after(endOfDay))
        return timeline
    }
}
