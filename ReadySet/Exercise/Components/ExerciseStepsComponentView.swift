//
//  ExerciseStepsComponentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI
import HealthKit

struct ExerciseStepsComponentView: View {
    @ObservedObject var exerciseViewModel: ExerciseViewModel

    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 35)
                .cornerRadius(35)
                .foregroundStyle(.thinMaterial)
                .shadow(radius: 1)

            HStack {
                Image(systemName: "shoeprints.fill")
                    .foregroundStyle(.green)
                    .shadow(radius: 1)

                Text("\(Int(exerciseViewModel.stepsToday)) / \(Int(exerciseViewModel.stepGoal))")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(.fontGray)

        }
    }
}

#Preview {
    ExerciseStepsComponentView(exerciseViewModel: ExerciseViewModel())
}
