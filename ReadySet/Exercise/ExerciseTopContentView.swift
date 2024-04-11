//
//  ExerciseTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct ExerciseTopContentView: View {
    @State private var stepCountGoal = 10000 //TODO: extract this
    
    var body: some View {
        HStack (spacing: 10) {
            ExerciseStatWidgetView()
            
            VStack (spacing: 10) {
                ExerciseStepsWidgetView(stepCountGoal: $stepCountGoal)
                
                ExerciseHealthWidgetView()
            }
        }
        .padding(.leading, 8)
        .padding(.top, 5)
        .frame(height: 85)
    }
}

#Preview {
    ExerciseTopContentView()
}
