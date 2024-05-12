//
//  SpeedometerGaugeStyle.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/27/24.
//

import SwiftUI

struct SpeedometerGaugeStyle: GaugeStyle {
    @Binding var isUpdating: Bool
    var level: Int
    var max: Double
    var unit: String
    var color: Color
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(.thickMaterial, lineWidth: 20)
                .rotationEffect(.degrees(135))

            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(color, lineWidth: 20)
                .rotationEffect(.degrees(135))

            VStack(spacing: 0) {
                if isUpdating {
                    ProgressView()
                        .tint(.white)
                        .controlSize(.extraLarge)
                        .frame(height: 40)

                } else {
                    Text(level.description)
                        .font(.system(size: 30))
                        .bold()
                        .shadow(radius: 5)
                        .foregroundStyle(LinearGradient(colors: [.base, .baseAccent], startPoint: .leading, endPoint: .trailing))
                        .animation(.easeInOut, value: level)
                        .transition(.blurReplace())
                        .frame(height: 40)
                }

                Text(unit)
                    .font(.caption)
                    .foregroundStyle(.base)
                    .bold()
                    .font(.body)
            }
            .frame(height: 90)
        }
        .frame(width: 120)
    }
}
