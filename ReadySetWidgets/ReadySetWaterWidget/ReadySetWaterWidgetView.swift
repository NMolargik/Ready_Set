//
//  ReadySetWaterWidgetView.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 4/28/24.
//

import SwiftUI
import WidgetKit

struct ReadySetWaterWidgetView : View {
    @Environment(\.widgetFamily) var widgetFamily
    @AppStorage("useMetric") var useMetric = false
    
    @State var waterBalance: Int = 100
    @State var waterGoal: Double = 128
    
    var entry: WaterWidgetProvider.Entry

    var body: some View {
        ZStack {
            Link(destination: URL(string: "readySet://Water")!) {
                GaugeView(max: $waterGoal, level: $waterBalance, isUpdating: .constant(false), color: WaterTabItem().color, unit: useMetric ? "mL" : "oz")
                    .frame(width: 150, height: 120)
            }
            
            VStack {
                Spacer()
                
                Button(action: {
                    withAnimation {
                        
                    }
                }, label: {
                    ZStack {
                        Rectangle()
                            .cornerRadius(20)
                            .foregroundStyle(.base)
                        
                        Text("+\(useMetric ? 1000 : 8)")
                            .bold()
                            .foregroundStyle(.black)
                    }
                })
                .frame(width: 70, height: 20)
                .shadow(radius: 5)
                .buttonStyle(.plain)
                .padding(.bottom, -5)
            }
        }
        .onChange(of: entry.date) {
            waterGoal = Double(entry.goal)
            waterBalance = Int(entry.consumption)
        }
        .widgetURL(URL(string: "readySet://Energy"))
    }
}
