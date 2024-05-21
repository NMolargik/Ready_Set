//
//  WaterWidgetProvider.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 4/28/24.
//

import WidgetKit
import SwiftUI

struct WaterWidgetProvider: TimelineProvider {
    typealias Entry = SimpleEntry

    init() {
        NotificationCenter.default.addObserver(forName: .consumptionReset, object: nil, queue: .main) { _ in
            WidgetCenter.shared.reloadTimelines(ofKind: "WaterWidget")
        }
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), consumption: DataService.shared.waterConsumedToday, goal: DataService.shared.waterGoal)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), consumption: DataService.shared.waterConsumedToday, goal: DataService.shared.waterGoal)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Current date entry
        let currentDate = Date()
        let currentEntry = SimpleEntry(date: currentDate, consumption: DataService.shared.waterConsumedToday, goal: DataService.shared.waterGoal)
        entries.append(currentEntry)

        // Next midnight entry
        if let nextMidnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 1, of: Date().addingTimeInterval(86400)) {
            let resetEntry = SimpleEntry(date: nextMidnight, consumption: 0, goal: DataService.shared.waterGoal)
            entries.append(resetEntry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
