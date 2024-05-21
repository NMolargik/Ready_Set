//
//  EnergyWidgetProvider.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 4/28/24.
//

import Foundation
import WidgetKit

struct EnergyWidgetProvider: TimelineProvider {
    typealias Entry = SimpleEntry

    init() {
        // Listen for the reset notification
        NotificationCenter.default.addObserver(forName: .consumptionReset, object: nil, queue: .main) { _ in
            WidgetCenter.shared.reloadTimelines(ofKind: "EnergyWidget")
        }
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), consumption: DataService.shared.energyConsumedToday, goal: DataService.shared.energyGoal)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), consumption: DataService.shared.energyConsumedToday, goal: DataService.shared.energyGoal)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Current date entry
        let currentDate = Date()
        let currentEntry = SimpleEntry(date: currentDate, consumption: DataService.shared.energyConsumedToday, goal: DataService.shared.energyGoal)
        entries.append(currentEntry)

        // Next midnight entry
        if let nextMidnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 1, of: Date().addingTimeInterval(86400)) {
            let resetEntry = SimpleEntry(date: nextMidnight, consumption: 0, goal: DataService.shared.energyGoal)
            entries.append(resetEntry)
        }

        // Schedule timeline
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
