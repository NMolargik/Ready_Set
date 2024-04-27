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
    @State private var isUpdating = false
    @State var rotation : Double = 0
    @State var orientation: WKInterfaceDeviceCrownOrientation = .right
    
    var addEnergyIntake: ((Int, @escaping (Bool) -> Void) -> Void)
    var requestEnergyBalanceUpdate: () -> Void
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
                .padding(.top, 1)
            
            VStack {
                
                if (orientation == .right) {
                    Spacer()
                }
                
                if isUpdating {
                    ProgressView()
                        .scaleEffect(2)
                        .tint(.orange)
                } else {
                    Text(energyBalance.description)
                        .font(.system(size: 45))
                        .foregroundStyle(WatchEnergyTabItem().gradient)
                        .animation(.easeInOut, value: energyBalance)
                        .transition(.blurReplace())
                }
                
                Text("of \(Int(energyGoal).description)")
                    .font(.system(size: 20))
                    .foregroundStyle(.fontGray)
                    
                Text("\(useMetric ? "kJ" : "cal") today")
                    .foregroundStyle(.fontGray)
                
                if (orientation == .left) {
                    Spacer()
                }
            }
            .blur(radius: isTurning ? 20 : 0)
            .animation(.easeInOut, value: isTurning)
            .bold()
            .font(.system(size: 20))
            .animation(.easeInOut, value: energyGoal)
            .transition(.blurReplace())
            
            CrownRotationAdditionView(isTurning: $isTurning, rotation: $rotation, min: 80 , max: 1000, step: 20, unitOfMeasurement: useMetric ? "kJ" : "cal", addColor: .orangeStart, gradient: WatchEnergyTabItem().gradient, onAdd: { energy in
                isUpdating = true
                isTurning = false
                rotation = 0.0
                addEnergyIntake(energy) { success in
                    DispatchQueue.main.async {
                        withAnimation {
                            requestEnergyBalanceUpdate()
                            //TODO: Add alert if failed
                        }
                    }
                }
            },
            onCancel: {
                withAnimation {
                    isTurning = false
                    rotation = 0.0
                }
            })
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
        energyBalance: .constant(5000),
        energyGoal: .constant(2300),
        useMetric: .constant(true),
        addEnergyIntake: { _,_ in
            return
        },
        requestEnergyBalanceUpdate: { return }
    )
}
