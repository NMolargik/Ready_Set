//
//  ExerciseTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct ExerciseTopContentView: View {
    @AppStorage("decreaseHaptics") var decreaseHaptics: Bool = false
    
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
                if (!decreaseHaptics) {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
                exerciseViewModel.proposedStepGoal = Int(stepSliderValue)
            }
            .onAppear {
                stepSliderValue = exerciseViewModel.stepGoal
            }
    }

    private var defaultView: some View {
        HStack {
            VStack(spacing: 10) {
                ExerciseStatWidgetView(totalSets: .constant(10), weeklySteps: .constant(exerciseViewModel.stepCountWeek.values.reduce(0, +))) //TODO: adjust this widget
                
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
