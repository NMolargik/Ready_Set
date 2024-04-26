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
    @State var rotation : Double = 0
    @State var orientation: WKInterfaceDeviceCrownOrientation = .right
    
    var addWaterIntake: ((Int) -> Bool)
    
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
            
            CrownRotationAdditionView(isTurning: $isTurning, rotation: $rotation, min: 8, max: 128, step: 2, unitOfMeasurement: useMetric ? "mL" : "oz", addColor: .blueStart, gradient: WatchWaterTabItem().gradient,
                onAdd: { water in
                Task {
                    withAnimation {
                        let success = addWaterIntake(water)
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
    
    private var waterAdditionView: some View {
        VStack {
            if orientation == .left && !isTurning {
                Spacer()
            }
            
            HStack {
                if orientation == .right && !isTurning {
                    Spacer()
                }
                
                VStack (spacing: 0) {
                    if (!isTurning) {
                        Image(systemName: "chevron.up")
                            .scaleEffect(y: 0.6)
                            .padding(.bottom, 4)
                    }
                    
                    Text("+\(Int(abs(rotation))) \(useMetric ? "mL" : "oz")")
                        .focusable(true)
                        .digitalCrownRotation($rotation)
                        .opacity(rotation == 0.0 ? 0 : 100)
                        .bold()
                        .font(.system(size: 30))
                        .foregroundStyle(WatchWaterTabItem().gradient)
                        .animation(.easeInOut, value: waterBalance)
                        .transition(.blurReplace())
                        .frame(width: isTurning ? 100 : 0, height: isTurning ? 40 : 0)
                        .shadow(color: .white, radius: 8)

                    HStack (spacing: 0) {
                        Button(action: {
                            withAnimation {
                                
                                //TODO: add water
                                isTurning = false
                                rotation = 0.0
                            }
                        }, label: {
                            Text("Add")
                                .bold()
                                .font(.system(size: isTurning ? 15 : 10))
                                .foregroundStyle(.blue)
                                .padding(.horizontal, isTurning ? 20 : 0)
                                .padding(.vertical, isTurning ? 10 : 0)
                                .frame(width: isTurning ? 80 : 20)
                                .background {
                                    if (isTurning) {
                                        Rectangle()
                                            .cornerRadius(10)
                                            .foregroundStyle(.white)
                                            .padding()
                                    }
                                }
                        })
                        .disabled(!isTurning)
                        .buttonStyle(.plain)
                        
                        Button(action: {
                            withAnimation {
                                isTurning = false
                                rotation = 0.0
                            }
                        }, label: {
                            Text("Cancel")
                                .bold()
                                .font(.system(size: isTurning ? 15 : 0))
                                .foregroundStyle(.white)
                                .padding(.horizontal, isTurning ? 5 : 0)
                                .padding(.vertical, isTurning ? 10 : 0)
                                .frame(width: isTurning ? 80 : 0)
                                .background {
                                    if (isTurning) {
                                        Rectangle()
                                            .cornerRadius(10)
                                            .foregroundStyle(.red)
                                            .padding()
                                    }
                                }
                        })
                        .disabled(!isTurning)
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 4)
                .frame(width: isTurning ? 150 : 30, height: isTurning ? 150 : 30)
                .background {
                    RoundedRectangle(cornerRadius: 20.0)
                        .foregroundStyle(.thinMaterial)
                        
                }
                
                if orientation == .left && !isTurning {
                    Spacer()
                }
            }
            
            if orientation == .right && !isTurning {
                Spacer()
            }
        }
        .animation(.easeInOut, value: isTurning)
        .transition(.opacity)
    }
}

#Preview {
    WatchWaterView(
        waterBalance: .constant(100),
        waterGoal: .constant(128),
        useMetric: .constant(true),
        addWaterIntake: { _ in
            return false
        })
}
