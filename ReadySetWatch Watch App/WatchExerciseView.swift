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
        ZStack {
            Color.black
                .ignoresSafeArea()
                .padding(.top, 1)
            
            VStack {
                if (orientation == .right) {
                    Spacer()
                }
                
                Text(stepsTaken.description)
                    .font(.system(size: 45))
                    .foregroundStyle(WatchExerciseTabItem().gradient)
                    .animation(.easeInOut, value: stepsTaken)
                    .transition(.blurReplace())

                Text("of \(Int(stepGoal).description)")
                    .font(.system(size: 20))
                    .foregroundStyle(.fontGray)

                Text("steps today")
                    .foregroundStyle(.fontGray)
                
                if (orientation == .left) {
                    Spacer()
                }
                
            }
            .bold()
            .font(.system(size: 20))
            .animation(.easeInOut, value: stepGoal)
            .transition(.blurReplace())
        }
        .onAppear {
            orientation = WKInterfaceDevice.current().crownOrientation
        }
    }
}

#Preview {
    WatchExerciseView(stepsTaken: .constant(10000), stepGoal: .constant(10000))
}
