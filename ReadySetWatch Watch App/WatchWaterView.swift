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
            VStack {
                Text(waterBalance.description)
                    .bold()
                    .font(.system(size: 40))
                    .foregroundStyle(.fontGray)
                    .animation(.easeInOut, value: waterBalance)
                    .transition(.blurReplace())
                
                Text("of")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundStyle(WatchWaterTabItem().gradient)
                
                
                Text(Int(waterGoal).description)
                    .bold()
                    .font(.system(size: 40))
                    .foregroundStyle(.fontGray)
                
                HStack {
                    Image("Droplet")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30)
                    
                    Text("\(useMetric ? "mL" : "oz") today")
                        .foregroundStyle(.fontGray)
                }
                .bold()
                .font(.system(size: 20))
                .animation(.easeInOut, value: waterGoal)
                .transition(.blurReplace())
            }
            
            CrownRotationAdditionView(isTurning: $isTurning, rotation: $rotation, min: 8, max: 128, step: 2, unitOfMeasurement: useMetric ? "mL" : "oz", addColor: .blueStart, gradient: WatchWaterTabItem().gradient, onAdd: { water in
                    isUpdating = true
                    addWaterIntake(water) { success in
                        DispatchQueue.main.async {
                            withAnimation {
                                requestWaterBalanceUpdate()
                                isTurning = success
                                
                                
                                //TODO: Add alert if appropriate
                                isUpdating = false
                                rotation = 0.0
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
