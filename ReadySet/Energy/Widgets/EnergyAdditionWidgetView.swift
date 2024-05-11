//
//  EnergyAdditionWidgetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI

struct EnergyAdditionWidgetView: View {
    @AppStorage("useMetric", store: UserDefaults(suiteName: Bundle.main.groupID)) var useMetric: Bool = false
    @AppStorage("decreaseHaptics") var decreaseHaptics: Bool = false
    
    var addEnergy: (Double) -> Void
    
    @State private var expanded = false
    @State private var energyToAdd: Double = 0
    @State private var lastCoordinateValue: CGFloat = 0.0
    
    var sliderRange: ClosedRange<Double> = 0...100
    
    var body: some View {
        HStack {
            GeometryReader { geometry in
                let minValue = geometry.size.width * 0.01 + 4
                let maxValue = (geometry.size.width * 0.98) - 40
                let scaleFactor = (maxValue - minValue) / (sliderRange.upperBound - sliderRange.lowerBound)
                let lower = sliderRange.lowerBound
                let sliderVal = (self.energyToAdd - lower) * scaleFactor + minValue
                
                ZStack {
                    Rectangle()
                        .cornerRadius(35)
                        .foregroundStyle(
                            energyToAdd > 7 ? EnergyTabItem().gradient : LinearGradient(colors: [.clear, Color.base.opacity(0.6)], startPoint: .leading, endPoint: .trailing))
                        .animation(.easeInOut, value: energyToAdd)
                        .frame(height: 50)
                    
                    HStack {
                        Text("cancel")
                            .bold()
                            .font(.caption)
                            .foregroundStyle(.white)
                            .opacity(energyToAdd > 7 ? 0.5 : 0)
                        
                        Spacer()
                        
                        Text("slide and release to consume \(useMetric ? "kiloJoules" : "calories")")
                            .bold()
                            .font(.caption)
                            .foregroundStyle(.base)
                            .colorInvert()
                            .opacity(energyToAdd > 7 ? 0 : 0.3)
                    }
                    .padding(.horizontal)
                    .frame(height: 50)
                    
                    HStack {
                        sliderHandle
                        .offset(x: sliderVal)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { dragValue in
                                    if (abs(dragValue.translation.width) < 0.1) {
                                    }
                                    if dragValue.translation.width > 0 {
                                        let nextCoordinateValue = min(maxValue, self.lastCoordinateValue + dragValue.translation.width)
                                        self.energyToAdd = ((nextCoordinateValue - minValue) / scaleFactor)  + lower
                                    } else {
                                        let nextCoordinateValue = max(minValue, self.lastCoordinateValue + dragValue.translation.width)
                                        self.energyToAdd = ((nextCoordinateValue - minValue) / scaleFactor) + lower
                                    }
                                    
                                    if (energyToAdd > 7 && !decreaseHaptics) {
                                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                    }
                                }
                                .onEnded { dragValue in
                                    let notificationFeedback = UINotificationFeedbackGenerator()
                                    notificationFeedback.prepare()
                                    
                                    if (abs(dragValue.translation.width) < 0.1) {
                                    }
                                    if dragValue.translation.width > 0 {
                                        let nextCoordinateValue = min(maxValue, self.lastCoordinateValue + dragValue.translation.width)
                                        self.energyToAdd = ((nextCoordinateValue - minValue) / scaleFactor)  + lower
                                    } else {
                                        let nextCoordinateValue = max(minValue, self.lastCoordinateValue + dragValue.translation.width)
                                        self.energyToAdd = ((nextCoordinateValue - minValue) / scaleFactor) + lower
                                    }
                                    
                                    if (energyToAdd > 7) {
                                        notificationFeedback.notificationOccurred(.success)
                                        
                                        withAnimation {
                                            let energyValue = Double(mapSliderValue(value: energyToAdd))
                                            addEnergy(energyValue)
                                        }
                                    }
                                    withAnimation (.bouncy) {
                                        energyToAdd = 0
                                    }
                                }
                        )
                        
                        Spacer()
                        
                    }
                    
                    if (energyToAdd > 7) {
                        ZStack {
                            Image(systemName: "bubble.middle.bottom.fill")
                                .font(.system(size: 50))
                                .shadow(radius: 2)
                                .scaleEffect(x: 1.5)
                                .foregroundStyle(.ultraThinMaterial)
                            
                            Text(Int(mapSliderValue(value: energyToAdd)).description)
                                .bold()
                                .foregroundStyle(.orangeEnd)
                                .font(.title)
                                .offset(y: -5)
                        }
                        
                        .offset(x: sliderVal - maxValue / 2 - 3, y: -50)
                        .frame(height: 50)
                    }
                }
            }
        }
        .frame(height: 50)
        .padding(10)
    }
    
    private var sliderHandle: some View {
        ZStack {
           Circle()
                .foregroundStyle(energyToAdd < 7 ? EnergyTabItem().gradient : LinearGradient(colors: [.fontGray, .fontGray], startPoint: .leading, endPoint: .trailing))
                .shadow(radius: 4, x: 2, y: 2)
                .frame(width: 40, height: 40)
            
            Image(systemName: "arrow.right")
                .bold()
                .foregroundStyle(.white)
                .font(.title2)
                .shadow(radius: energyToAdd > 7 ? 0 : 2)
                .opacity(energyToAdd > 7 ? 0 : 1)
            
            Text(useMetric ? "kJ" : "cal")
                .bold()
                .font(.caption2)
                .foregroundStyle(.white)
                .opacity(energyToAdd < 7 ? 0 : 1)
        }
    }
    
    private func mapSliderValue(value: Double) -> Int {
        return 1000 * (Int(value.rounded(.up)) ) / (100)
    }
}

#Preview {
    EnergyAdditionWidgetView(
        addEnergy: {_ in}
    )
}
