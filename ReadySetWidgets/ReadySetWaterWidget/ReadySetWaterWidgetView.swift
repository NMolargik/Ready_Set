//
//  ReadySetWaterWidgetView.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 4/28/24.
//

import SwiftUI
import WidgetKit

struct ReadySetWaterWidgetView: View {
    @Environment(\.widgetFamily) var widgetFamily

    var entry: WaterWidgetProvider.Entry

    var body: some View {
        ZStack {
            Link(destination: URL(string: "readySet://water")!) {
                GaugeView(max: DataService.shared.$waterGoal, level: DataService.shared.$waterConsumedToday, isUpdating: .constant(false), color: WaterTabItem().color, unit: DataService.shared.useMetric ? "mL" : "oz")
                    .frame(width: 150, height: 120)
            }

            VStack {
                Spacer()

                Button(intent: WaterIntent()) {
                    ZStack {
                        Rectangle()
                            .cornerRadius(20)
                            .foregroundStyle(.white)

                        Text("+\(DataService.shared.useMetric ? 240 : 8)")
                            .bold()
                            .foregroundStyle(.black)
                    }
                }
                .frame(width: 70, height: 30)
                .shadow(radius: 5)
                .buttonStyle(.plain)
                .padding(.bottom, -5)
            }
        }
        .widgetURL(URL(string: "readySet://water"))
    }
}
