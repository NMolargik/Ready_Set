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

    var body: some View {
        VStack {
            GaugeView(max: $stepGoal, level: $stepsTaken, isUpdating: .constant(false), color: ExerciseTabItem().color, unit: " steps")
                .frame(height: 120)
            
            if (stepsTaken == 0 || stepGoal == 1000) {
                HStack (alignment: .center) {
                    Text("You may need\nto open Ready, Set")
                        .font(.system(size: 10))
                    
                    Image(systemName: "applewatch.radiowaves.left.and.right")
                        
                }
                .frame(height: 30)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.white)
                .animation(.easeInOut, value: stepsTaken)
                    
            }
        }
        .bold()
        .font(.system(size: 20))
        .animation(.easeInOut, value: stepGoal)
        .transition(.blurReplace())
    }
}

#Preview {
    WatchExerciseView(stepsTaken: .constant(10000), stepGoal: .constant(10000))
}
