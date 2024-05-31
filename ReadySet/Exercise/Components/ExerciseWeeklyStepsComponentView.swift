//
//  ExerciseWeeklyStepsComponentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct ExerciseWeeklyStepsComponentView: View {
    @ObservedObject var exerciseViewModel: ExerciseViewModel

    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(35)
                .foregroundStyle(.thinMaterial)
                .shadow(radius: 1)

            Text("Weekly Steps: \(exerciseViewModel.stepCountWeek.values.reduce(0, +))")
                .font(.caption)
                .foregroundStyle(.fontGray)
        }
        .frame(height: 35)
    }
}

#Preview {
    ExerciseWeeklyStepsComponentView(exerciseViewModel: ExerciseViewModel())
}
