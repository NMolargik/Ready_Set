//
//  WaterWidgetProvider.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 4/28/24.
//

import Foundation
import WidgetKit

struct WaterWidgetProvider: TimelineProvider {
    let data = DataService.shared

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), consumption: data.waterConsumedToday, goal: data.waterGoal)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), consumption: data.waterConsumedToday, goal: data.waterGoal)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: Date())!
            let entry = SimpleEntry(date: entryDate, consumption: data.waterConsumedToday, goal: data.waterGoal)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
