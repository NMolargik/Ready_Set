//
//  ExerciseTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct ExerciseTopContentView: View {
    @ObservedObject var exerciseViewModel: ExerciseViewModel

    var body: some View {
        ZStack {
            contentView

            HStack {
                Spacer()

                editGoalButton
            }
        }
        .padding(.leading, 8)
        .padding(.top, 5)
    }

    private var contentView: some View {
        HStack(spacing: 10) {
            if exerciseViewModel.editingStepGoal {
                stepGoalEditor
            } else {
                defaultView
            }
        }
    }

    private var stepGoalEditor: some View {
        SliderView(range: 1000...15000, gradient: ExerciseTabItem().gradient, step: 1000, label: "steps", sliderValue: $exerciseViewModel.stepSliderValue)
            .onAppear {
                exerciseViewModel.stepSliderValue = exerciseViewModel.stepGoal
            }
    }

    private var defaultView: some View {
        HStack {
            VStack(spacing: 10) {
                ExerciseHealthComponentView()

                ExerciseFitnessComponentView()
            }
            VStack(spacing: 10) {
                ExerciseStepsComponentView(exerciseViewModel: exerciseViewModel)

                ExerciseWeeklyStepsComponentView(exerciseViewModel: exerciseViewModel)

            }
        }
    }

    private var editGoalButton: some View {
        Button(action: {
            withAnimation {
                exerciseViewModel.editingStepGoal.toggle()
                if !exerciseViewModel.editingStepGoal {
                    exerciseViewModel.saveStepGoal()
                }
            }
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }) {
            Text(exerciseViewModel.editingStepGoal ? "Save Goal" : "Edit Goal")
                .bold()
                .foregroundStyle(.greenEnd)
                .transition(.opacity)
        }
        .offset(y: -62)
        .buttonStyle(.plain)
    }
}

#Preview {
    ExerciseTopContentView(exerciseViewModel: ExerciseViewModel())
}
