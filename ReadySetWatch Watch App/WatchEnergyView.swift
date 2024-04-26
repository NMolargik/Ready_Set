//
//  WatchEnergyView.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import SwiftUI

struct WatchEnergyView: View {
    @Binding var energyBalance: Int
    @Binding var energyGoal: Double
    @Binding var useMetric: Bool
    
    var addEnergyIntake: ((Int) -> Bool)
    
    var body: some View {
        VStack {
            Text(energyBalance.description)
                .bold()
                .font(.system(size: 40))
                .foregroundStyle(.fontGray)
                .animation(.easeInOut, value: energyBalance)
                .transition(.blurReplace())

            Text("of")
                .bold()
                .font(.system(size: 20))
                .foregroundStyle(WatchEnergyTabItem().gradient)
            
            
            Text(Int(energyGoal).description)
                .bold()
                .font(.system(size: 40))
                .foregroundStyle(.fontGray)
            
            HStack {
                Image("Flame")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30)
                
                Text("\(useMetric ? "kJ" : "cal") today")
                    .foregroundStyle(.fontGray)
            }
            .bold()
            .font(.system(size: 20))
            .animation(.easeInOut, value: energyGoal)
            .transition(.blurReplace())
        }
    }
}

#Preview {
    WatchEnergyView(
        energyBalance: .constant(1000),
        energyGoal: .constant(2300),
        useMetric: .constant(true),
        addEnergyIntake: { _ in
            return false
        })
}
