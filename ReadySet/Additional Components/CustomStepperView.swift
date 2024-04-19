//
//  CustomStepperView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/19/24.
//

import SwiftUI

struct CustomStepperView: View {
    @Binding var value: Int
    var step: Int
    var iconName: String
    var colors: [Color]
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Image(systemName: iconName)
                .foregroundStyle(LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
                .frame(width: 20)
            
            Text("\(value)")
                .bold()
                .foregroundStyle(.baseInvert)
                .frame(width: 50)
            
            Stepper(value: customBinding, step: step, label: {EmptyView()})
                .labelsHidden()
                .colorMultiply(colors[1])
        }
        .onChange(of: value) {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        }
    }
    
    private var customBinding: Binding<Int> {
        Binding(
            get: { self.value },
            set: { newValue in
                self.value = max(0, newValue)
            }
        )
    }
}
