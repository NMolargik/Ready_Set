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
    
    @State private var isTurning = false
    @State private var isUpdating = false
    @State var rotation : Double = 0
    @State var orientation: WKInterfaceDeviceCrownOrientation = .right
    
    var addWaterIntake: ((Int, @escaping (Bool) -> Void) -> Void)
    var requestWaterBalanceUpdate: () -> Void
    
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
                        .tint(.blue)
                } else {
                    Text(waterBalance.description)
                        .font(.system(size: 45))
                        .foregroundStyle(WatchWaterTabItem().gradient)
                        .animation(.easeInOut, value: waterBalance)
                        .transition(.blurReplace())
                }
                
                Text("of \(Int(waterGoal).description)")
                    .font(.system(size: 20))
                    .foregroundStyle(.fontGray)
                    
                Text("\(useMetric ? "mL" : "oz") today")
                    .foregroundStyle(.fontGray)
                
                if (orientation == .left) {
                    Spacer()
                }
            }
            .blur(radius: isTurning ? 20 : 0)
            .animation(.easeInOut, value: isTurning)
            .bold()
            .font(.system(size: 20))
            .animation(.easeInOut, value: waterGoal)
            .transition(.blurReplace())

            CrownRotationAdditionView(isTurning: $isTurning, rotation: $rotation, min: 8, max: 128, step: 2, unitOfMeasurement: useMetric ? "mL" : "oz", addColor: .blueEnd, gradient: WatchWaterTabItem().gradient, onAdd: { water in
                isUpdating = true
                isTurning = false
                rotation = 0.0
                addWaterIntake(water) { success in
                    DispatchQueue.main.async {
                        withAnimation {
                            requestWaterBalanceUpdate()
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
        .onAppear {
            orientation = WKInterfaceDevice.current().crownOrientation
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
        .onChange(of: waterBalance) {
            withAnimation {
                isUpdating = false
            }
        }
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
