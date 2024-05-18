//
//  ExerciseBottomContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import SwiftUI
import SwiftData

struct ExerciseBottomContentView: View {
    @Query(sort: [SortDescriptor(\Exercise.orderIndex)]) var exercises: [Exercise]
    @Environment(\.modelContext) var modelContext
    @State var exerciseViewModel: ExerciseViewModel
    @Binding var selectedDay: Int

    var body: some View {
        ZStack {
            @State var exercises = exercises.filter({$0.weekday == selectedDay})

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
                                for exercise in exercises.filter({$0.weekday == selectedDay}) {
                                    modelContext.delete(exercise: exercise)
                                }
                            }
                        }, label: {
                            Text("Clear All")
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

                ExercisePlanDayView(exerciseViewModel: exerciseViewModel, exercises: $exercises, selectedDay: selectedDay)
            }

            VStack {
                Spacer()

                HStack(spacing: 8) {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
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
                    .padding(.vertical, 2)
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
                        .font(.footnote)
                        .foregroundStyle(.fontGray)
                        .frame(width: 30)

                    Button(action: {
                        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
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
                    .padding(.vertical, 2)
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
                .drawingGroup()
                .padding(.horizontal, 30)
                .padding(.vertical, 2)
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
                .padding(.vertical, 2)
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
                .foregroundStyle(.fontGray, .base)
                .font(.system(size: 25))
                .tag("editButton")
        })

        .shadow(radius: 3)
        .buttonStyle(.plain)
        .bold()
    }
}

#Preview {
    ExerciseBottomContentView(exerciseViewModel: ExerciseViewModel(), selectedDay: .constant(0))
}
