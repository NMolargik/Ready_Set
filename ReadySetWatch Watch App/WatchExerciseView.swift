//
//  WatchExerciseView.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import SwiftUI
import HealthKit

struct WatchExerciseView: View {
    @Binding var stepsTaken: Int
    @Binding var stepGoal: Double
    @State var orientation: WKInterfaceDeviceCrownOrientation = .right

    var body: some View {
        VStack {
            GaugeView(max: $stepGoal, level: $stepsTaken, isUpdating: .constant(false), color: WatchExerciseTabItem().color, unit: " steps")
                .frame(height: 120)
                .padding(.bottom, 20)
        }
        .bold()
        .font(.system(size: 20))
        .animation(.easeInOut, value: stepGoal)
        .transition(.blurReplace())
        .onAppear {
            orientation = WKInterfaceDevice.current().crownOrientation
        }
    }
}

#Preview {
    WatchExerciseView(stepsTaken: .constant(10000), stepGoal: .constant(10000))
}
