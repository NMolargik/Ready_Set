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
            HStack (spacing: 10) {
                if (exerciseViewModel.editingStepGoal) {
                    VStack (alignment: .center, spacing: 0) {
                        Text("\(Int(stepSliderValue))")
                            .bold()
                            .font(.title)
                            .id(stepSliderValue.description)

                        Text("steps")
                            .bold()
                            .font(.caption2)
                    }
                    .frame(width: 110)
                    .transition(.opacity)
                    
                    ZStack {
                        Rectangle()
                            .frame(height: 80)
                            .cornerRadius(20)
                            .foregroundStyle(.thinMaterial)
                            .shadow(radius: 1)
                        
                        ExerciseTabItem().gradient
                        .mask(Slider(value: $stepSliderValue, in: 1000...15000, step: 1000))
                        .padding(.horizontal)
                        
                        Slider(value: $stepSliderValue, in: 1000...15000, step: 1000)
                            .opacity(0.05)
                            .padding(.horizontal)
                    }
                    .onAppear {
                        stepSliderValue = exerciseViewModel.stepGoal
                    }
                    .onChange(of: stepSliderValue) { _ in
                        UINotificationFeedbackGenerator().notificationOccurred(.warning) //TODO: make custom haptics and extract them
                        exerciseViewModel.proposedStepGoal = Int(stepSliderValue)
                    }
                } else {
                    VStack (spacing: 10) {
                        ExerciseStatWidgetView()
                        
                        ExerciseFitnessWidgetView()
                    }
                    
                    VStack (spacing: 10) {
                        ExerciseStepsWidgetView(exerciseViewModel: exerciseViewModel)
                        
                        ExerciseHealthWidgetView()
                    }
                }
            }
            
            HStack {
                Spacer()
                
                Button(action: {
                    withAnimation {
                        if (exerciseViewModel.editingStepGoal) {
                            exerciseViewModel.saveStepGoal()
                        } else {
                            exerciseViewModel.editingStepGoal = true
                        }
                    }
                }, label: {
                    Text(exerciseViewModel.editingStepGoal ? "Save Goal" : "Edit Goal")
                        .bold()
                        .foregroundStyle(.greenEnd)
                        .transition(.opacity)
                })
            }
            .offset(y: -62)
        }
        
        .padding(.leading, 8)
        .padding(.top, 5)
        .onAppear {
            withAnimation {
                exerciseViewModel.readInitial()
            }
        }
    }
}

#Preview {
    ExerciseTopContentView(exerciseViewModel: ExerciseViewModel())
}
