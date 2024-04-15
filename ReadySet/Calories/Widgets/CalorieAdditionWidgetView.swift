//
//  CalorieAdditionWidgetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI

struct CalorieAdditionWidgetView: View {
    @ObservedObject var calorieViewModel: CalorieViewModel
    
    @State private var expanded = false
    @State var value: Double = 0
    @State private var caloriesToAdd : Double = 0
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
                        .foregroundStyle(
                            value > 7 ? CalorieTabItem().gradient : LinearGradient(colors: [.clear, .fontGray.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
                    

                    HStack {
                        Text("cancel")
                            .bold()
                            .font(.caption)
                            .foregroundStyle(.white)
                            .opacity(value > 7 ? 0.5 : 0)
                        
                        Spacer()
                        
                        Text("slide and release to add calories")
                            .bold()
                            .font(.caption)
                            .foregroundStyle(.white)
                            .opacity(value > 7 ? 0 : 0.5)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        ZStack {
                            Rectangle()
                                .cornerRadius(35)
                                .foregroundStyle(value < 7 ? CalorieTabItem().gradient : LinearGradient(colors: [.fontGray, .fontGray], startPoint: .leading, endPoint: .trailing))
                                .shadow(radius: 4, x: 2, y: 2)
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "plus")
                                .bold()
                                .foregroundStyle(.white)
                                .font(.title2)
                                .shadow(radius: value > 7 ? 0 : 2)
                                .opacity(value > 7 ? 0 : 1)
                            
                            Text("cal")
                                .bold()
                                .font(.caption2)
                                .foregroundStyle(.white)
                                .opacity(value < 7 ? 0 : 1)
                        }
                        .foregroundColor(Color.yellow)
                        .offset(x: sliderVal)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { dragValue in
                                    if (abs(dragValue.translation.width) < 0.1) {
                                    }
                                    if dragValue.translation.width > 0 {
                                        let nextCoordinateValue = min(maxValue, self.lastCoordinateValue + dragValue.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor)  + lower
                                    } else {
                                        let nextCoordinateValue = max(minValue, self.lastCoordinateValue + dragValue.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor) + lower
                                    }
                                }
                                .onEnded { dragValue in
                                    if (abs(dragValue.translation.width) < 0.1) {
                                    }
                                    if dragValue.translation.width > 0 {
                                        let nextCoordinateValue = min(maxValue, self.lastCoordinateValue + dragValue.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor)  + lower
                                    } else {
                                        let nextCoordinateValue = max(minValue, self.lastCoordinateValue + dragValue.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor) + lower
                                    }
                                    
                                    if (value > 4) {
                                        withAnimation {
                                            let calorieValue = Double(mapSliderValue(value: value))
                                            print(calorieValue)
                                            calorieViewModel.addCalories(calories: calorieValue)
                                        }
                                    }
                                    
                                    value = 0
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
    
    func mapSliderValue(value: Double) -> Int {
        return 1000 * (Int(value.rounded(.up)) ) / (100)
    }
}

#Preview {
    CalorieAdditionWidgetView(calorieViewModel: CalorieViewModel())
}