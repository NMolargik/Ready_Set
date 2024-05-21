//
//  ExerciseBottomContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import SwiftUI
import SwiftData

struct ExerciseBottomContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Exercise.orderIndex)]) var exercises: [Exercise]
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    @Binding var selectedDay: Int

    var filteredExercises: [Exercise] {
        exercises.filter {$0.weekday == selectedDay}
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Text(exerciseViewModel.weekDays[selectedDay])
                        .bold()
                        .font(.largeTitle)
                        .foregroundStyle(.baseInvert)

                    Spacer()

                    if exerciseViewModel.editingSets && exercises.count > 0 {
                        Button(action: {
                            withAnimation {
                                for exercise in filteredExercises {
                                    modelContext.delete(exercise: exercise)
                                }
                            }
                        }, label: {
                            Text("Delete All")
                                .foregroundStyle(.red)
                                .font(.body)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 5)
                                .background {
                                    Rectangle()
                                        .cornerRadius(10)
                                        .foregroundStyle(.baseAccent)
                                        .shadow(radius: 3)
                                }
                        })
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 10)

                ExercisePlanDayView(exerciseViewModel: exerciseViewModel, exercises: .constant(filteredExercises), selectedDay: selectedDay, hideNudge: false)
            }

            VStack {
                Spacer()

                HStack(spacing: 8) {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        withAnimation {
                            selectedDay -= 1
                        }
                    }, label: {
                        Image(systemName: "chevron.left")
                            .bold()
                            .foregroundStyle(.fontGray)
                    })
                    .buttonStyle(.plain)
                    .disabled(selectedDay == 0)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .background {
                        Rectangle()
                            .cornerRadius(10)
                            .foregroundStyle(.base)
                            .shadow(radius: 3)
                    }
                    .padding(.leading, 10)

                    Text(exerciseViewModel.weekDays[selectedDay].prefix(3))
                        .bold()
                        .font(.body)
                        .foregroundStyle(.fontGray)
                        .frame(width: 40)

                    Button(action: {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        withAnimation {
                            selectedDay += 1
                        }
                    }, label: {
                        Image(systemName: "chevron.right")
                            .bold()
                            .foregroundStyle(.fontGray)
                    })
                    .buttonStyle(.plain)
                    .disabled(selectedDay == 6)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .background {
                        Rectangle()
                            .cornerRadius(10)
                            .foregroundStyle(.base)
                            .shadow(radius: 3)
                    }

                    Spacer()

                    if !exerciseViewModel.editingSets {
                        expandButton
                            .transition(.opacity)
                    }

                    editButton
                        .transition(.opacity)
                }
                .padding(.vertical, 2)
                .drawingGroup()
                .padding(.horizontal, 30)
                .onAppear {
                    withAnimation {
                        exerciseViewModel.getCurrentWeekday()
                        selectedDay = exerciseViewModel.currentDay - 1
                    }
                }
                .background {
                    Rectangle()
                        .foregroundStyle(.baseAccent)
                        .shadow(radius: exerciseViewModel.expandedSets ? 0 : 5, x: 0, y: exerciseViewModel.expandedSets ? 0 : -10)
                }
            }
        }
        .geometryGroup()
    }

    private var expandButton: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            withAnimation(.easeInOut) {
                exerciseViewModel.expandedSets.toggle()
            }
        }, label: {
            Text(exerciseViewModel.expandedSets ? "Collapse" : "View All")
                .foregroundStyle(.fontGray)
                .font(.body)
                .tag("expandButton")
                .padding(.vertical, 3)
                .padding(.horizontal, 5)
                .background {
                    Rectangle()
                        .cornerRadius(10)
                        .foregroundStyle(.base)
                        .shadow(radius: 3)
                }
        })
        .buttonStyle(.plain)
        .bold()
        .padding(.trailing, 5)
    }

    private var editButton: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            withAnimation(.easeInOut) {
                exerciseViewModel.editingSets.toggle()
            }
        }, label: {
            Image(systemName: exerciseViewModel.editingSets ? "checkmark.circle.fill" : "pencil.circle.fill")
                .foregroundStyle(.green, .base)
                .font(.system(size: 25))
                .tag("editButton")
        })

        .shadow(radius: 3)
        .buttonStyle(.plain)
        .bold()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Exercise.self, configurations: config)
    let mockExercise = Exercise(weekday: 1, orderIndex: 1, name: "Sample Exercise")
    container.mainContext.insert(mockExercise)

    return ExerciseBottomContentView(exerciseViewModel: ExerciseViewModel(), selectedDay: .constant(0))
        .environment(\.modelContext, container.mainContext)
}
