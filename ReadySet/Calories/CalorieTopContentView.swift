//
//  CalorieTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct CalorieTopContentView: View {
    @ObservedObject var calorieViewModel: CalorieViewModel
    
    @State var progress: CGFloat
    @State private var opacity = 0.0
    @State private var fahrenheit = 400.0
    
    let gradient = Gradient(colors: [.orangeStart, .orangeEnd])

    private let minValue = 0.0
    private let maxValue = 570.0
    
    var body: some View {
        HStack (spacing: 5) {
            VStack {
                Gauge(value: fahrenheit, in: minValue...maxValue) {
                }
                .tint(gradient)
                .shadow(radius: 1)
                
                HStack {
                    VStack (alignment: .leading) {
                        Text("\(Int(fahrenheit)) / \(Int(maxValue)) Consumed")
                           .bold()
                           .foregroundColor(.fontGray)
                        
                        Text("\(Int(minValue)) Burned")
                            .bold()
                            .foregroundColor(.fontGray)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        UIApplication.shared.open(URL(string: "x-fitness://")!)
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(height: 40)
                                .cornerRadius(10)
                                .foregroundStyle(.thinMaterial)
                                .shadow(radius: 1)
                            
                            Image(systemName: "circle.circle")
                                .foregroundStyle(.green, .red, .yellow)
                        }
                    })
                    
                    Button(action: {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        UIApplication.shared.open(URL(string: "x-apple-health://")!)
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(height: 40)
                                .cornerRadius(10)
                                .foregroundStyle(.thinMaterial)
                                .shadow(radius: 1)
                            
                            Image(systemName: "heart")
                            .foregroundStyle(.pink)
                        }
                    })
                }
                
                Spacer()
            }
            .padding(.leading, 8)
            .padding(.top, 8)
        }
    }
}

#Preview {
    CalorieTopContentView(calorieViewModel: CalorieViewModel(), progress: 0.5)
}
