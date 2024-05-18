//
//  EnergyWidgetProvider.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 4/28/24.
//

import Foundation
import WidgetKit

struct EnergyWidgetProvider: TimelineProvider {
    var energy: EnergyViewModel = .shared

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), consumption: energy.energyConsumedToday, goal: energy.energyGoal)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), consumption: energy.energyConsumedToday, goal: energy.energyGoal)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let currentDate = Date()
        let startOfDay = Calendar.current.startOfDay(for: currentDate)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let entry = SimpleEntry(date: startOfDay, consumption: 0, goal: energy.energyGoal)
        let timeline = Timeline(entries: [entry], policy: .after(endOfDay))
        completion(timeline)
    }
}
