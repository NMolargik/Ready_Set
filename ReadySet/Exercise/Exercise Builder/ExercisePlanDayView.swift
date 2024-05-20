//
//  ExercisePlanDayView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import SwiftUI
import SwiftData

struct ExercisePlanDayView: View {
    @Environment(\.modelContext) var modelContext
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    @Binding var exercises: [Exercise]
    var selectedDay: Int
    var hideNudge: Bool

    var body: some View {
        ScrollView {
            LazyVStack {
                if exercises.count == 0 && !exerciseViewModel.editingSets && !hideNudge {
                    VStack(spacing: 20) {
                        Spacer(minLength: 100)

                        Text("No Exercises Today")
                            .bold()
                            .font(.title)

                        Image(systemName: "rectangle.and.text.magnifyingglass")
                            .font(.largeTitle)

                        Text("Tap the pencil icon below to add to your workout.")
                            .bold()
                            .multilineTextAlignment(.center)

                    }
                    .foregroundStyle(.fontGray)
                }

                ForEach(exercises, id: \.self) { exercise in
                    ExerciseEntryView(exerciseViewModel: exerciseViewModel, exercise: exercise)
                        .id(exercise.id)
                }
                .animation(.smooth, value: exercises)

                if exerciseViewModel.editingSets {
                    HStack {
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            withAnimation {
                                let exercise = Exercise(weekday: selectedDay, orderIndex: exercises.count + 1)
                                modelContext.insert(exercise)
                                exerciseViewModel.selectedExercise = exercise
                            }
                        }, label: {
                            Text("Add Exercise")
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
                                .foregroundStyle(.greenEnd)
                                .shadow(radius: 5)
                        }
                        .padding(.leading, 5)

                        Spacer()
                    }
                    .animation(.easeInOut, value: exercises.count)
                    .transition(.move(edge: .leading))

                }

                if exerciseViewModel.editingSets {
                    Spacer(minLength: 400)
                }
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 30)
        }
        .scrollDisabled(exerciseViewModel.disableScroll())
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Exercise.self, configurations: config)
    let mockExercise = Exercise(weekday: 1, orderIndex: 1, name: "Sample Exercise")
    container.mainContext.insert(mockExercise)

    return ExercisePlanDayView(exerciseViewModel: ExerciseViewModel(), exercises: .constant([mockExercise]), selectedDay: 1, hideNudge: false)
        .environment(\.modelContext, container.mainContext)
}
