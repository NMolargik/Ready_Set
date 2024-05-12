//
//  SwiftUIView.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/18/24.
//

import SwiftUI

struct ExerciseSetEditor: View {
    @Binding var exerciseSet: ExerciseSet

    var body: some View {
        HStack {
            VStack(spacing: 2) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    withAnimation {
                        exerciseSet.goalType = .weight
                    }
                }, label: {
                    Text("Reps")
                        .bold()
                        .padding(.horizontal, 5)
                        .padding(.vertical, 3)
                        .foregroundStyle(.baseInvert)
                        .frame(width: 80)
                        .background {
                            Rectangle()
                                .cornerRadius(5)
                                .foregroundStyle(exerciseSet.goalType == .weight ? .greenEnd : .baseAccent)
                        }
                })
                .buttonStyle(.plain)

                Button(action: {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    withAnimation {
                        exerciseSet.goalType = .duration
                    }
                }, label: {
                    Text("Duration")
                        .bold()
                        .padding(.horizontal, 5)
                        .padding(.vertical, 3)
                        .foregroundStyle(.baseInvert)
                        .frame(width: 80)
                        .background {
                            Rectangle()
                                .cornerRadius(5)
                                .foregroundStyle(exerciseSet.goalType == .duration ? .purpleEnd : .baseAccent)
                        }
                })
                .frame(width: 80)
                .buttonStyle(.plain)
            }

            VStack(spacing: 2) {
                if exerciseSet.goalType == .duration {
                    CustomStepperView(value: $exerciseSet.durationToDo, step: 5, iconName: "stopwatch.fill", colors: [.purpleStart, .purpleEnd])

                } else {
                    CustomStepperView(value: $exerciseSet.weightToLift, step: 5, iconName: "dumbbell.fill", colors: [.greenStart, .greenEnd])

                    CustomStepperView(value: $exerciseSet.repetitionsToDo, step: 1, iconName: "repeat", colors: [.orangeStart, .orangeEnd])
                }
            }
            .padding(.vertical, 3)
            .animation(.easeInOut, value: exerciseSet.goalType)
            .transition(.opacity)
        }
        .compositingGroup()
        .compositingGroup()
        .padding(3)
        .background {
            Rectangle()
                .foregroundStyle(.baseInvert)
                .cornerRadius(5)
                .shadow(radius: 5, x: 3, y: 3)
        }
    }
}

#Preview {
    ExerciseSetEditor(exerciseSet: .constant(ExerciseSet()))
}
