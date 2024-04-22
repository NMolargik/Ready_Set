//
//  ExerciseSetRecordView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/22/24.
//

import SwiftUI
import Flow

struct ExerciseSetRecordView: View {
    @Binding var exercise: Exercise
    @Binding var selectedSet: String
    
    var body: some View {
        HFlow(itemSpacing: 10, rowSpacing: 8) {
            ForEach($exercise.exerciseSets.sorted(by: { $0.wrappedValue.timestamp < $1.wrappedValue.timestamp }), id: \.id) { $set in
                if ($set.id.uuidString == selectedSet) {
                    HStack {
                        VStack(spacing: 0) {
                            if set.goalType == .duration {
                                CustomStepperView(value: $set.durationToDo, step: 5, iconName: "stopwatch.fill", colors: [.purpleStart, .purpleEnd])
                                
                            } else {
                                CustomStepperView(value: $set.weightToLift, step: 5, iconName: "dumbbell.fill", colors: [.greenStart, .greenEnd])
                                
                                CustomStepperView(value: $set.repetitionsToDo, step: 1, iconName: "repeat", colors: [.orangeStart, .orangeEnd])
                            }
                        }
                        
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedSet = ""
                            }
                        }, label: {
                            Text("Save")
                                .foregroundStyle(.greenEnd)
                                .bold()
                        })
                        .buttonStyle(.plain)
                        .padding(.horizontal, 5)
                    }
                    .padding(.vertical, 3)
                    .padding(.horizontal, 5)
                    .background(
                        Rectangle()
                            .foregroundStyle(.baseAccent)
                            .shadow(radius: 5)
                            .cornerRadius(5)
                    )
                    .compositingGroup()
                    .animation(.easeInOut, value: selectedSet)
                    .padding(.leading)
                    
                } else {
                    ExerciseSetCapsuleView(set: set, selectedSet: $selectedSet)
                        .id(set.id)
                }
            }
        }
    }
}

#Preview {
    ExerciseSetRecordView(exercise: .constant(Exercise()), selectedSet: .constant(""))
}
