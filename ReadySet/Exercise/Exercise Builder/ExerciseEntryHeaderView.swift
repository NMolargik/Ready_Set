//
//  ExerciseEntryHeaderView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/19/24.
//

import SwiftUI

struct ExerciseEntryHeaderView: View {
    @Environment(\.modelContext) var modelContext
    
    @State var exercise: Exercise
    @Binding var isEditing: Bool
    @Binding var selectedExercise: Exercise
    @Binding var selectedSet: String
    @FocusState private var focusTextField
    var keyboardShown: FocusState<Bool>.Binding
    
    var body: some View {
        HStack (spacing: 0) {
            if (isEditing) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation {
                        modelContext.delete(exercise: exercise)
                    }
                }, label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundStyle(LinearGradient(colors: [.orangeStart, .orangeEnd], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 15, height: 15)
                })
                .buttonStyle(.plain)
                .shadow(radius: 5)
            }
            
            if (exercise.id == selectedExercise.id && isEditing) {
                TextField("Exercise Name", text: $selectedExercise.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: selectedExercise.name) {
                        withAnimation {
                            exercise.name = selectedExercise.name
                        }
                    }
                    .frame(maxWidth: 200, alignment: .leading)
                    .scaleEffect(0.9)
                    .focused($focusTextField)
                    .onAppear {
                        focusTextField = true
                    }
                
            } else {
                Text(exercise.name)
                    .lineLimit(1)
                    .padding(.horizontal, 5)
                    .fontWeight(.semibold)
                    .foregroundStyle(.baseInvert)
                    .truncationMode(.tail)
            }
            
            if (isEditing) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation {
                        if (selectedExercise.id == exercise.id) {
                            exercise.name = selectedExercise.name == "" ? "Unnamed Exercise" : selectedExercise.name
                            selectedExercise = Exercise()
                        } else {
                            selectedExercise = exercise
                            exercise.name = ""
                        }
                    }
                }, label: {
                    Image(systemName: selectedExercise.id == exercise.id ? "checkmark.circle.fill" : "ellipsis.rectangle")
                        .foregroundStyle(.baseInvert)
                        .frame(width: 15, height: 15)
                })
                .shadow(radius: 5)
                .padding(.leading, 20)
                .buttonStyle(.plain)
                .id(exercise.id.uuidString)
            }
            
            Spacer()
            
            if (isEditing) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation {
                        let newSet = ExerciseSet(goalType: .weight, repetitionsToDo: 5, durationToDo: 10, weightToLift: 100)
                        exercise.exerciseSets.append(newSet)
                        modelContext.insert(newSet)
                        selectedSet = newSet.id.uuidString
                    }
                }, label: {
                    HStack (spacing: 0) {
                        Text("Set")
                            .bold()
                            .foregroundStyle(.baseInvert)
                            
                            .padding(.vertical, 2)
                            .shadow(radius: 5)
                        
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(LinearGradient(colors: [.greenStart, .greenEnd], startPoint: .leading, endPoint: .trailing))
                            .frame(height: 15)
                            .padding(.horizontal, 2)
                    }
                })
                .buttonStyle(.plain)
            }
        }
        .transition(.move(edge: .leading))
    }
}
