//
//  WaterAdditionWidgetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/11/24.
//

import SwiftUI
import Foundation

struct WaterAdditionWidgetView: View {
    var addWater: (Double) -> Void
    
    @State private var expanded = false
    @State var value: Double = 0
    @State private var waterToAdd : Double = 0
    @State var lastCoordinateValue: CGFloat = 0.0
    
    var sliderRange: ClosedRange<Double> = 0...100
    
    var body: some View {
        HStack {
            GeometryReader { geometry in
                let minValue = geometry.size.width * 0.01 + 4
                let maxValue = (geometry.size.width * 0.98) - 40
                let scaleFactor = (maxValue - minValue) / (sliderRange.upperBound - sliderRange.lowerBound)
                let lower = sliderRange.lowerBound
                let sliderVal = (self.value - lower) * scaleFactor + minValue
                
                ZStack {
                    Rectangle()
                        .cornerRadius(35)
                        .foregroundStyle(value > 7 ? WaterTabItem().gradient : LinearGradient(colors: [.clear, Color.base.opacity(0.6)], startPoint: .leading, endPoint: .trailing))
                    
                    HStack {
                        Text("cancel")
                            .bold()
                            .font(.caption)
                            .foregroundStyle(.white)
                            .opacity(value > 7 ? 0.5 : 0)
                        
                        Spacer()
                        
                        Text("slide and release to consume water")
                            .bold()
                            .font(.caption)
                            .foregroundStyle(.base)
                            .colorInvert()
                            .opacity(value > 7 ? 0 : 0.3)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        sliderHandle
                        .offset(x: sliderVal)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { dragValue in
                                    if dragValue.translation.width > 0 {
                                        let nextCoordinateValue = min(maxValue, self.lastCoordinateValue + dragValue.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor)  + lower
                                    } else {
                                        let nextCoordinateValue = max(minValue, self.lastCoordinateValue + dragValue.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor) + lower
                                    }
                                }
                                .onEnded { dragValue in
                                    if dragValue.translation.width > 0 {
                                        let nextCoordinateValue = min(maxValue, self.lastCoordinateValue + dragValue.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor)  + lower
                                    } else {
                                        let nextCoordinateValue = max(minValue, self.lastCoordinateValue + dragValue.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor) + lower
                                    }
                                    
                                    if (value > 4) {
                                        withAnimation {
                                            let waterValue = Double(mapSliderValue(value: value))
                                            print(waterValue)
                                            addWater(waterValue)
                                        }
                                    }
                                    
                                    withAnimation (.bouncy) {
                                        value = 0
                                    }
                                }
                        )
                        
                        Spacer()
                    }
                    
                    if (value > 7) {
                        Text(Int(mapSliderValue(value: value)).description)
                            .bold()
                            .font(.title)
                            .foregroundStyle(.primary)
                            .shadow(radius: 2)
                            .offset(x: sliderVal - maxValue / 2, y: -50)
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
                .foregroundStyle(value < 7 ? WaterTabItem().gradient : LinearGradient(colors: [.fontGray, .fontGray], startPoint: .leading, endPoint: .trailing))
                .shadow(radius: 4, x: 2, y: 2)
                .frame(width: 40, height: 40)
            
            Image(systemName: "arrow.right")
                .bold()
                .foregroundStyle(.white)
                .font(.title2)
                .shadow(radius: value > 7 ? 0 : 2)
                .opacity(value > 7 ? 0 : 1)
            
            Text("oz")
                .bold()
                .font(.caption2)
                .foregroundStyle(.white)
                .opacity(value < 7 ? 0 : 1)
        }
    }
    
    func mapSliderValue(value: Double) -> Int {
        return (-5 + (128 + 5) * (Int(value.rounded(.up))) / 100)
    }
}

#Preview {
    WaterAdditionWidgetView(
        addWater: { _ in }
    )
}
