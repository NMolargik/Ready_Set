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

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), consumption: DataService.shared.energyConsumedToday, goal: DataService.shared.energyGoal)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), consumption: DataService.shared.energyConsumedToday, goal: DataService.shared.energyGoal)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
            let entry = SimpleEntry(date: Date(), consumption: DataService.shared.energyConsumedToday, goal: DataService.shared.energyGoal)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
}
