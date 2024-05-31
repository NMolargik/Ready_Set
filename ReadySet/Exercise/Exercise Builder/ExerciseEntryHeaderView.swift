//
//  ExerciseEntryHeaderView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/19/24.
//

import SwiftUI
import SwiftData

struct ExerciseEntryHeaderView: View {
    @Environment(\.modelContext) var modelContext
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    @State var exercise: Exercise
    @FocusState private var focusTextField

    var body: some View {
        HStack(spacing: 0) {
            if exerciseViewModel.editingSets {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation {
                        modelContext.delete(exercise: exercise)
                    }
                }, label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundStyle(.white, LinearGradient(colors: [.red, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 15, height: 15)
                })
                .buttonStyle(.plain)
                .shadow(radius: 5)
            }

            if editingExerciseName() {
                TextField("Exercise Name", text: $exerciseViewModel.selectedExercise.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: exerciseViewModel.selectedExercise.name) {
                        withAnimation {
                            exercise.name = exerciseViewModel.selectedExercise.name
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
                    .foregroundStyle(.fontGray)
                    .truncationMode(.tail)
            }

            if exerciseViewModel.editingSets {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation {
                        if exerciseViewModel.selectedExercise.id == exercise.id {
                            exercise.name = exerciseViewModel.selectedExercise.name == "" ? "Unnamed Exercise" : exerciseViewModel.selectedExercise.name
                            exerciseViewModel.selectedExercise = Exercise()
                        } else {
                            exerciseViewModel.selectedExercise = exercise
                            exercise.name = ""
                        }
                    }
                }, label: {
                    Image(systemName: exerciseViewModel.selectedExercise.id == exercise.id ? "checkmark.circle.fill" : "ellipsis.rectangle")
                        .foregroundStyle(.baseInvert)
                        .frame(width: 15, height: 15)
                })
                .shadow(radius: 5)
                .padding(.leading, 20)
                .buttonStyle(.plain)
                .id(exercise.id.uuidString)
            }

            Spacer()

            if exerciseViewModel.editingSets {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation(.snappy) {
                        let newSet = ExerciseSet(goalType: .weight, repetitionsToDo: 5, durationToDo: 10, weightToLift: 100)
                        exercise.exerciseSets.append(newSet)
                        modelContext.insert(newSet)
                        exerciseViewModel.selectedSet = newSet.id.uuidString
                    }
                }, label: {
                    Text("Add Set")
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .shadow(radius: 5)
                })
                .buttonStyle(.plain)
                .background {
                    Rectangle()
                        .cornerRadius(5)
                        .foregroundStyle(.orangeStart)
                        .shadow(radius: 5)
                }
                .padding(.trailing, 5)
            }
        }
        .transition(.move(edge: .leading))
        .padding(.leading, 5)
    }

    func editingExerciseName() -> Bool {
        return (exercise.id == exerciseViewModel.selectedExercise.id && exerciseViewModel.editingSets)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Exercise.self, configurations: config)
    let mockExercise = Exercise(weekday: 1, orderIndex: 1, name: "Sample Exercise")
    container.mainContext.insert(mockExercise)

    return ExerciseEntryHeaderView(exerciseViewModel: ExerciseViewModel(), exercise: mockExercise)
        .environment(\.modelContext, container.mainContext)
}
