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

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), consumption: DataService.shared.waterConsumedToday, goal: DataService.shared.waterGoal)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), consumption: DataService.shared.waterConsumedToday, goal: DataService.shared.waterGoal)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let entry = SimpleEntry(date: Date(), consumption: DataService.shared.waterConsumedToday, goal: DataService.shared.waterGoal)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}
