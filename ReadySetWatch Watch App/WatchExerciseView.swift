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
            Text(stepsTaken.description)
                .bold()
                .font(.system(size: 40))
                .foregroundStyle(.fontGray)
                .animation(.easeInOut, value: stepsTaken)
                .transition(.blurReplace())

            Text("of")
                .bold()
                .font(.system(size: 20))
                .foregroundStyle(WatchExerciseTabItem().gradient)
            
            
            Text(Int(stepGoal).description)
                .bold()
                .font(.system(size: 40))
                .foregroundStyle(.fontGray)
            
            HStack {
                Image(systemName: "shoeprints.fill")
                    .foregroundStyle(WatchExerciseTabItem().gradient)
                
                Text("Steps Taken")
                    .foregroundStyle(.fontGray)
            }
            .bold()
            .font(.system(size: 20))
            .animation(.easeInOut, value: stepGoal)
            .transition(.blurReplace())
        }
    }
}

#Preview {
    WatchExerciseView(stepsTaken: .constant(35), stepGoal: .constant(10000))
}
