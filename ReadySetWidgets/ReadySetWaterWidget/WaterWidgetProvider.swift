//
//  WaterWidgetProvider.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 4/28/24.
//

import WidgetKit
import SwiftUI
import Intents

struct WaterWidgetProvider: AppIntentTimelineProvider {
    typealias Entry = SimpleEntry
    typealias Intent = SelectWaterIncrementIntent

    var water: WaterViewModel = .shared

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), consumption: water.waterConsumedToday, goal: water.waterGoal)
    }

    func snapshot(for configuration: SelectWaterIncrementIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), consumption: water.waterConsumedToday, goal: water.waterGoal)
    }

    func timeline(for configuration: SelectWaterIncrementIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let currentDate = Date()
        let startOfDay = Calendar.current.startOfDay(for: currentDate)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        let entry = SimpleEntry(date: startOfDay, consumption: water.waterConsumedToday, goal: water.waterGoal)
        let timeline = Timeline(entries: [entry], policy: .after(endOfDay))
        return timeline
    }
}
