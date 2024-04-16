//
//  ExerciseTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct ExerciseTopContentView: View {
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    @State private var stepSliderValue: Double = 0
    
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
        .onAppear {
            exerciseViewModel.readInitial()
            stepSliderValue = exerciseViewModel.stepGoal // Initialize slider
        }
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
        SliderView(range: 1000...15000, gradient: ExerciseTabItem().gradient, step: 1000, label: "steps", sliderValue: $stepSliderValue)
            .onChange(of: stepSliderValue) { _ in
                exerciseViewModel.proposedStepGoal = Int(stepSliderValue)
            }
    }

    private var defaultView: some View {
        HStack {
            VStack(spacing: 10) {
                ExerciseStatWidgetView(totalSets: $exerciseViewModel.totalSetCount, weeklySteps: .constant(exerciseViewModel.stepCountWeek.values.reduce(0, +)))
                
                ExerciseFitnessWidgetView()
            }
            VStack(spacing: 10) {
                ExerciseStepsWidgetView(exerciseViewModel: exerciseViewModel)
                ExerciseHealthWidgetView()
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
        }) {
            Text(exerciseViewModel.editingStepGoal ? "Save Goal" : "Edit Goal")
                .bold()
                .foregroundStyle(.greenEnd)
                .transition(.opacity)
        }
        .offset(y: -62)
    }
}

#Preview {
    ExerciseTopContentView(exerciseViewModel: ExerciseViewModel())
}
