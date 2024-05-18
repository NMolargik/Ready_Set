//
//  WaterWidgetProvider.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 4/28/24.
//

import Foundation
import WidgetKit

struct WaterWidgetProvider: TimelineProvider {
    var water: WaterViewModel = .shared

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), consumption: water.waterConsumedToday, goal: water.waterGoal)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), consumption: water.waterConsumedToday, goal: water.waterGoal)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let currentDate = Date()
        let startOfDay = Calendar.current.startOfDay(for: currentDate)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let entry = SimpleEntry(date: startOfDay, consumption: 0, goal: water.waterGoal)
        let timeline = Timeline(entries: [entry], policy: .after(endOfDay))
        completion(timeline)
    }
}
