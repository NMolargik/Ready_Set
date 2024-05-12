//
//  GaugeView.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/27/24.
//

import SwiftUI

struct GaugeView: View {
    @Binding var max: Double
    @Binding var level: Int
    @Binding var isUpdating: Bool
    var color: Color
    var unit: String

    var body: some View {
        Gauge(value: Double(level), in: 0...Double(max)) {
            Text(Int(level).description)
        }
        .gaugeStyle(SpeedometerGaugeStyle(isUpdating: $isUpdating, level: level, max: max, unit: unit, color: color))
        .frame(width: 100)
        .animation(.easeInOut, value: level)
    }
}

#Preview {
    GaugeView(max: .constant(100), level: .constant(50), isUpdating: .constant(true), color: .blue, unit: "oz")
}
