//
//  ReadySetEnergyWidgetView.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 4/28/24.
//

import SwiftUI

struct ReadySetEnergyWidgetView: View {
    @Environment(\.widgetFamily) var widgetFamily
    
    let data = DataService()
    var entry: EnergyWidgetProvider.Entry

    var body: some View {
        ZStack {
            Link(destination: URL(string: "readySet://Energy")!) {
                GaugeView(max: .constant(entry.goal), level: .constant(entry.consumption), isUpdating: .constant(false), color: EnergyTabItem().color, unit: data.useMetric ? "kJ" : "cal")
                    .frame(width: 150, height: 120)
            }
                
            VStack {
                Spacer()
                
                Button(intent: EnergyIntent()) {
                    ZStack {
                        Rectangle()
                            .cornerRadius(20)
                            .foregroundStyle(.white)
                        
                        Text("+\(data.useMetric ? 800 : 200)")
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
        .widgetURL(URL(string: "readySet://Energy"))
    }
}
