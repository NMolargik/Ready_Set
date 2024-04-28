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
    
    @State private var isAdding = false
    @State private var isUpdating = false
    @State private var amountToAdd: Double = 0
    @State private var showAlert = false
    
    var addEnergyIntake: ((Int, @escaping (Bool) -> Void) -> Void)
    var requestEnergyBalanceUpdate: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                GaugeView(max: $energyGoal, level: $energyBalance, isUpdating: $isUpdating, color: EnergyTabItem().color, unit: useMetric ? "kJ" : "cal")
                    .frame(height: 120)
                
                Button(action: {
                    withAnimation {
                        isAdding = true
                    }
                }, label: {
                    ZStack {
                        Circle()
                            .foregroundStyle(.base)
                        
                        Image("Flame")
                            .resizable()
                            .scaledToFill()
                            .padding(5)
                        
                        Image(systemName: "plus")
                            .font(.caption)
                            .foregroundStyle(.base)
                            .offset(y: 4)
                    }
                })
                .buttonStyle(.plain)
                .frame(width: 40)
                .padding(.top, -20)
            }
            .blur(radius: isAdding ? 20 : 0)
            .animation(.easeInOut, value: isAdding)
            .bold()
            .font(.system(size: 20))
            .animation(.easeInOut, value: energyGoal)
            .transition(.blurReplace())
            
            if (isAdding) {
                CrownRotationAdditionView(amount: $amountToAdd, min: 8, max: energyGoal, step: 20, unitOfMeasurement: useMetric ? "kJ" : "cal", gradient: EnergyTabItem().gradient, onAdd: { amount in
                    withAnimation {
                        isUpdating = true
                        isAdding = false
                    }
                    
                    if (amount > 0) {
                        addEnergyIntake(Int(amount)) { success in
                            WKInterfaceDevice.current().play(.success)
                            
                            withAnimation {
                                amountToAdd = 0
                                isUpdating = false
                            }
                        }
                    } else {
                        withAnimation {
                            amountToAdd = 0
                            isUpdating = false
                        }
                    }
                }, onCancel: {
                    withAnimation {
                        amountToAdd = 0
                        isAdding = false
                    }
                })
            }
        }
        .onChange(of: energyBalance) {
            withAnimation {
                isUpdating = false
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
