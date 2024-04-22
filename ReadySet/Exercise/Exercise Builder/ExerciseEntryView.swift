//
//  ExerciseEntryView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/19/24.
//

import SwiftUI
import Flow

struct ExerciseEntryView: View {
    @Environment(\.modelContext) var modelContext
    @State var exercise: Exercise
    @Binding var isEditing: Bool
    @Binding var selectedExercise: Exercise
    @Binding var selectedSet: String
    
    var keyboardShown: FocusState<Bool>.Binding
    

    var body: some View {
        VStack (spacing: 5) {
            ExerciseEntryHeaderView(exercise: exercise, isEditing: $isEditing, selectedExercise: $selectedExercise, selectedSet: $selectedSet, keyboardShown: keyboardShown)
            
            VStack (spacing: 0) {
                if (exercise.exerciseSets.count == 0 ) {
                    HStack {
                        Text("No sets added yet")
                            .font(.caption)
                            .foregroundStyle(.baseInvert)
                            .transition(.opacity)
                        
                        Spacer()
                    }
                    .padding(.leading)
                }
                
                if (isEditing) {
                    ForEach($exercise.exerciseSets.sorted(by: { $0.wrappedValue.timestamp < $1.wrappedValue.timestamp }), id: \.id) { $set in
                        HStack {
                            ExerciseSetEditor(exerciseSet: $set)
                                .padding(.bottom, 4)
                            
                            Button(action: {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                withAnimation {
                                    exercise.exerciseSets.remove(at: exercise.exerciseSets.firstIndex(of: set) ?? 0)
                                    modelContext.delete(set)
                                }
                            }, label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundStyle(LinearGradient(colors: [.orangeStart, .orangeEnd], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 15, height: 15)
                            })
                            .buttonStyle(.plain)
                            .shadow(radius: 5)
                        }
                    }
                } else {
                    HStack {
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
            }
            .padding(.bottom, 5)
            .onChange(of: isEditing) {
                if (!isEditing) {
                    selectedSet = ""
                }
            }
        }
    }
}
