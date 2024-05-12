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
        VStack(spacing: 5) {
            ExerciseEntryHeaderView(exercise: exercise, isEditing: $isEditing, selectedExercise: $selectedExercise, selectedSet: $selectedSet, keyboardShown: keyboardShown)
                .animation(.easeInOut, value: selectedExercise)

            VStack(spacing: 0) {
                if exercise.exerciseSets.count == 0 {
                    HStack {
                        Text("No sets added yet")
                            .font(.caption)
                            .foregroundStyle(.baseInvert)
                            .transition(.opacity)

                        Spacer()
                    }
                    .padding(.leading)
                }

                if isEditing {
                    ForEach($exercise.exerciseSets.sorted(by: { $0.wrappedValue.timestamp < $1.wrappedValue.timestamp }), id: \.id) { $set in
                        HStack {
                            ExerciseSetEditor(exerciseSet: $set)
                                .padding(.bottom, 4)

                            Button(action: {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                withAnimation {
                                    modelContext.delete(set)
                                    exercise.exerciseSets.remove(at: exercise.exerciseSets.firstIndex(of: set) ?? 0)
                                }
                            }, label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundStyle(.white, LinearGradient(colors: [.red, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 15, height: 15)
                            })
                            .buttonStyle(.plain)
                            .shadow(radius: 5)
                        }
                    }
                } else {
                    HStack {
                        ExerciseSetRecordView(exercise: $exercise, selectedSet: $selectedSet)
                    }
                }
            }
            .padding(.bottom, 5)
            .onChange(of: isEditing) {
                if !isEditing {
                    selectedSet = ""
                }
            }
        }
    }
}
