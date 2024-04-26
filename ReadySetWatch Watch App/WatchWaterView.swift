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
            
            VStack {
                if orientation == .left && !isTurning {
                    Spacer()
                }
                
                HStack {
                    if orientation == .right && !isTurning {
                        Spacer()
                    }
                    
                    VStack (spacing: 5) {
                        Image(systemName: "chevron.up")
                            .scaleEffect(y: 0.6)
                        
                        Text("Add")
                            .bold()
                            .font(.system(size: 10))
                            .foregroundStyle(.blueEnd)
                        
                        
                        Text("Rotation \(rotation)")
                            .focusable()
                            .digitalCrownRotation($rotation)
                    }
                    .padding(.top, 4)
                    
                    if orientation == .left && !isTurning {
                        Spacer()
                    }
                }
                
                if orientation == .right && !isTurning {
                    Spacer()
                }
            }
        }
        .onAppear {
            orientation = WKInterfaceDevice.current().crownOrientation
        }
//        .onChange(of: rotation) {
//            print(rotation)
//            withAnimation {
//                if rotation != 0.0 {
//                    isTurning = true
//                } else {
//                    isTurning = false
//                }
//            }
//        }
        
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
