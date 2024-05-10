//
//  ReadySetEnergyWidget.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 4/28/24.
//

import WidgetKit
import SwiftUI

struct ReadySetEnergyWidget: Widget {
    let kind: String = "ReadySetEnergyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: EnergyWidgetProvider()) { entry in
            ReadySetEnergyWidgetView(entry: entry)
                .containerBackground(EnergyTabItem().gradient, for: .widget)

        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Ready, Set, Energy")
        .description("Quickly add new energy consumption to Ready, Set")
    }
}

#Preview(as: .systemSmall) {
    ReadySetEnergyWidget()
} timeline: {
    SimpleEntry(date: Date(), consumption: 500, goal: 2300)
    SimpleEntry(date: Date(), consumption: 1200, goal: 2300)
}
