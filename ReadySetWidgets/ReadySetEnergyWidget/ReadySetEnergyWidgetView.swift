//
//  ReadySetEnergyWidgetView.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 4/28/24.
//

import SwiftUI

struct ReadySetEnergyWidgetView: View {
    @Environment(\.widgetFamily) var widgetFamily
    @AppStorage("useMetric") var useMetric = false
    
    @State var energyBalance: Int = 1200
    @State var energyGoal: Double = 2300
    
    var entry: EnergyWidgetProvider.Entry

    var body: some View {
        ZStack {
            Link(destination: URL(string: "readySet://Energy")!) {
                GaugeView(max: $energyGoal, level: $energyBalance, isUpdating: .constant(false), color: EnergyTabItem().color, unit: useMetric ? "kJ" : "cal")
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
        .onAppear {
            energyGoal = Double(entry.goal)
            energyBalance = Int(entry.consumption)
        }
        .onChange(of: entry.date) {
            energyGoal = Double(entry.goal)
            energyBalance = Int(entry.consumption)
        }
        .widgetURL(URL(string: "readySet://Energy"))
    }
}
