//
//  ReadySetWaterWidget.swift
//  ReadySetWidgets
//
//  Created by Nick Molargik on 4/28/24.
//

import WidgetKit
import SwiftUI

struct ReadySetWaterWidget: Widget {
    let kind: String = "ReadySetWaterWidget"
    @State var waterWidgetProvider: WaterWidgetProvider = WaterWidgetProvider()

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: waterWidgetProvider) { entry in
            ReadySetWaterWidgetView(entry: entry)
                .containerBackground(WaterTabItem().gradient, for: .widget)
                .onAppear {
                    waterWidgetProvider.water.readWaterConsumedToday()
                }
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Ready, Set, Water")
        .description("Quickly add new water consumption to Ready, Set")
    }
}

#Preview(as: .systemSmall) {
    ReadySetWaterWidget()
} timeline: {
    SimpleEntry(date: Date(), consumption: 100, goal: 128)
    SimpleEntry(date: Date(), consumption: 110, goal: 128)
}
