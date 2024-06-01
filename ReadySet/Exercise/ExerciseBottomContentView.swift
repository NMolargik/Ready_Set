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
        exercises.filter { $0.weekday == selectedDay }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center) {
                Group {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        withAnimation {
                            if selectedDay > 0 {
                                selectedDay -= 1
                            } else {
                                selectedDay = 6
                            }
                        }
                    }, label: {
                        Image(systemName: "chevron.left")
                            .bold()
                            .foregroundStyle(.baseAccent)
                            .padding(8)
                            .background(
                                Circle()
                                    .foregroundColor(Color.fontGray)
                                    .shadow(radius: 8, x: 3, y: 3)
                            )
                    })
                    .buttonStyle(.plain)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)

                    Spacer()

                    Text(exerciseViewModel.weekDays[selectedDay])
                        .fontWeight(.semibold)
                        .font(.title)
                        .foregroundStyle(.baseInvert.gradient)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .transition(.scale(scale: 1.5).combined(with: .opacity))
                        .id(selectedDay)

                    Spacer()

                    Button(action: {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        withAnimation {
                            if selectedDay < 6 {
                                selectedDay += 1
                            } else {
                                selectedDay = 0
                            }
                        }
                    }, label: {
                        Image(systemName: "chevron.right")
                            .bold()
                            .foregroundStyle(.baseAccent)
                            .padding(8)
                            .background(
                                Circle()
                                    .foregroundColor(Color.fontGray)
                                    .shadow(radius: 8, x: 3, y: 3)
                            )
                    })
                    .buttonStyle(.plain)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                }

                Button(action: {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    withAnimation {
                        exerciseViewModel.editingSets.toggle()
                    }
                }, label: {
                    Image(systemName: exerciseViewModel.editingSets ? "checkmark" : "pencil")
                        .bold()
                        .foregroundStyle(.white)
                        .padding(6)
                        .background(
                            Circle()
                                .foregroundColor(Color.greenEnd)
                                .shadow(radius: 8, x: 3, y: 3)
                        )
                })
                .buttonStyle(.plain)
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color.base)
                    .shadow(radius: 3)
                    .frame(height: 50)
            )
            .frame(width: 300)

            ZStack {
                ExercisePlanDayView(exerciseViewModel: exerciseViewModel, exercises: .constant(filteredExercises), selectedDay: selectedDay, hideNudge: false)
                    .padding(.top, 10)

                VStack {
                    Spacer()
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 50)
                }
            }
        }
        .padding(.vertical, 10)
        .edgesIgnoringSafeArea(.bottom)
        .geometryGroup()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Exercise.self, configurations: config)
    let mockExercise = Exercise(weekday: 1, orderIndex: 1, name: "Sample Exercise")
    container.mainContext.insert(mockExercise)

    return ExerciseBottomContentView(exerciseViewModel: ExerciseViewModel(), selectedDay: .constant(1))
        .environment(\.modelContext, container.mainContext)
}
