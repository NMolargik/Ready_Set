//
//  SliderView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI

struct SliderView: View {
    let range: ClosedRange<Double>
    let gradient: LinearGradient
    let step: Double
    let label: String
    
    @Binding var sliderValue: Double
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack (alignment: .center, spacing: 0) {
                Text("\(Int(sliderValue))")
                    .bold()
                    .font(.title)
                    .id(sliderValue.description)
                
                Text(label)
                    .bold()
                    .font(.caption2)
            }
            .frame(width: 110)
            .transition(.opacity)
            
            ZStack {
                Rectangle()
                    .frame(height: 80)
                    .cornerRadius(20)
                    .foregroundStyle(.thinMaterial)
                    .shadow(radius: 1)
                
                gradient
                    .mask(Slider(value: $sliderValue, in: range, step: step))
                    .padding(.horizontal)
                
                Slider(value: $sliderValue, in: range, step: step)
                    .opacity(0.05)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    SliderView(range: 0...100, gradient: ExerciseTabItem().gradient, step: 10, label: "units", sliderValue: .constant(20))
}
