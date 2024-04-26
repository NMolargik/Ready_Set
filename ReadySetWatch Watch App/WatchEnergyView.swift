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
    
    @State private var isTurning = false
    @State var rotation : Double = 0
    
    var addEnergyIntake: ((Int) -> Bool)
    
    var body: some View {
        ZStack {
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
            
            CrownRotationAdditionView(isTurning: $isTurning, rotation: $rotation, min: 80 , max: 1000, step: 20, unitOfMeasurement: useMetric ? "kJ" : "cal", addColor: .orangeStart, gradient: WatchEnergyTabItem().gradient, 
                onAdd: { energy in
                Task {
                    withAnimation {
                        let success = addEnergyIntake(energy)
                        if (success) {
                            isTurning = false
                            rotation = 0.0
                        } else {
                            //TODO: show an alert
                            print("ouch")
                        }
                    }
                }
                    
                },
                onCancel: {
                    withAnimation {
                        isTurning = false
                        rotation = 0.0
                    }
                }
            )
        }
        
        .onChange(of: rotation) {
            print(rotation)
            withAnimation {
                if rotation != 0.0 {
                    isTurning = true
                } else {
                    isTurning = false
                }
            }
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
