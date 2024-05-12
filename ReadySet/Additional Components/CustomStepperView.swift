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
                .foregroundStyle(.base)
                .frame(width: 50)

            Stepper(value: customBinding, step: step, label: {EmptyView()})
                .labelsHidden()
                .accentColor(.base)
        }
        .onChange(of: value) {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        }
        .onAppear {
            UIStepper.appearance().setDecrementImage(UIImage(systemName: "minus"), for: .normal)
            UIStepper.appearance().setIncrementImage(UIImage(systemName: "plus"), for: .normal)
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
