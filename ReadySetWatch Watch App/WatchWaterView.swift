//
//  WatchWaterView.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import SwiftUI

struct WatchWaterView: View {
    @Binding var waterBalance: Int
    @Binding var waterGoal: Double
    @Binding var useMetric: Bool
    
    @State private var isAdding = false
    @State private var isUpdating = false
    @State private var amountToAdd: Double = 0
    @State private var showAlert = false
    
    var addWaterIntake: ((Int, @escaping (Bool) -> Void) -> Void)
    var requestWaterBalanceUpdate: () -> Void
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                GaugeView(max: $waterGoal, level: $waterBalance, isUpdating: $isUpdating, color: WatchWaterTabItem().color, unit: useMetric ? "mL" : "oz")
                    .frame(height: 120)
                
                Button(action: {
                    withAnimation {
                        isAdding = true
                    }
                }, label: {
                    ZStack {
                        Circle()
                            .foregroundStyle(.base)
                        
                        Image("Droplet")
                            .resizable()
                            .scaledToFill()
                            .padding(5)
                        
                        Image(systemName: "plus")
                            .foregroundStyle(.base)
                            .offset(y: 3)
                        
                    }
                })
                .buttonStyle(.plain)
                .frame(width: 40)
                .padding(.top, -20)
            }
            .blur(radius: isAdding ? 20 : 0)
            .animation(.easeInOut, value: amountToAdd)
            .bold()
            .font(.system(size: 20))
            .animation(.easeInOut, value: waterGoal)
            .transition(.blurReplace())

            if (isAdding) {
                CrownRotationAdditionView(amount: $amountToAdd, min: 8, max: waterGoal, step: 1, unitOfMeasurement: useMetric ? "mL" : "oz", gradient: WatchWaterTabItem().gradient, onAdd: { amount in
                    
                    withAnimation {
                        isAdding = false
                        isUpdating = true
                    }
                    
                    addWaterIntake(Int(amount)) { success in
                        WKInterfaceDevice.current().play(success ? .success : .failure)
                        
                        if (!success) {
                            showAlert = true
                        }
                        
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
        .onChange(of: waterBalance) {
            withAnimation {
                isUpdating = false
            }
        }
        .alert("There was an issue communicating with Ready, Set", isPresented: $showAlert, actions: {
            Button(action: {
                withAnimation {
                    showAlert = false
                }
            }, label: {
                Text("Okay")
            })
        })
    }
}

#Preview {
    WatchWaterView(
        waterBalance: .constant(100),
        waterGoal: .constant(128),
        useMetric: .constant(true),
        addWaterIntake: { _,_  in
            return
        },
        requestWaterBalanceUpdate: { return }
    )
}
