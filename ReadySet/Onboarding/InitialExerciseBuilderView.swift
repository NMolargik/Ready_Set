//
//  InitialExerciseBuilderView..swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI
import SwiftData

struct InitialExerciseBuilderView: View {
    @AppStorage("appState", store: UserDefaults(suiteName: Bundle.main.groupID)) var appState: String = "initialExerciseBuilder"
    @Query(sort: [SortDescriptor(\Exercise.orderIndex)]) var exercises: [Exercise]
    @Environment(\.modelContext) var modelContext
    @ObservedObject var exerciseViewModel: ExerciseViewModel = .shared

    @Binding var onboardingProgress: Float
    @Binding var onboardingGradient: LinearGradient

    @State private var showText = false
    @State private var showMoreText = false
    @State private var selectedDay = 1

    var filteredExercises: [Exercise] {
            exercises.filter {$0.weekday == selectedDay}
        }

    var body: some View {
        ZStack {
            Color.base
            VStack {
                if showText {
                    Spacer()

                    Text("Now add exercises and sets to each day. Ready, Set helps you track your weekly weight, repetition, and duration on sets.")
                        .multilineTextAlignment(.center)
                        .font(.body)
                        .foregroundStyle(.fontGray)
                        .padding(7)
                        .transition(.push(from: .top))
                }

                ZStack {
                    Rectangle()
                        .cornerRadius(35)
                        .foregroundStyle(.thickMaterial)
                        .shadow(radius: 1)

                    VStack {
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

                            ExercisePlanDayView(exerciseViewModel: exerciseViewModel, exercises: .constant(filteredExercises), selectedDay: selectedDay, hideNudge: true)
                        }
                    }

                    VStack {
                        Spacer()

                        HStack(spacing: 8) {
                            Spacer()

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
                            .padding(.vertical, 4)
                            .padding(.horizontal, 10)
                            .background {
                                Rectangle()
                                    .cornerRadius(10)
                                    .foregroundStyle(.base)
                                    .shadow(radius: 3)
                            }

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
                            .padding(.vertical, 4)
                            .padding(.horizontal, 10)
                            .background {
                                Rectangle()
                                    .cornerRadius(10)
                                    .foregroundStyle(.base)
                                    .shadow(radius: 3)
                            }

                            Spacer()
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
                                .shadow(radius: 5, x: 0, y: -10)
                        }
                    }
                }
                .geometryGroup()
                .mask {
                    Rectangle()
                        .cornerRadius(35)
                }
                .padding(.horizontal, 15)

                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation(.easeInOut) {
                        onboardingProgress = 0.75
                        onboardingGradient = LinearGradient(colors: [.greenStart, .blueEnd, .orangeStart], startPoint: .leading, endPoint: .trailing)
                        appState = "goalSetView"
                    }
                }, label: {
                    Text("Tap Here When Finished")
                        .font(.body)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .padding(8)
                        .id("InstructionText")
                        .zIndex(1)
                })
                .background {
                    Rectangle()
                        .cornerRadius(5)
                        .foregroundStyle(.blue)
                        .shadow(radius: 5)
                }
                .padding(.bottom, 30)
                .padding(.top, 20)
                .buttonStyle(.plain)
            }
            .padding(.top, 60)
        }
        .onAppear {
            withAnimation {
                getCurrentWeekday()
                exerciseViewModel.editingSets = true
                animateText()
            }
        }
        .onDisappear {
            exerciseViewModel.editingSets = false
        }
    }

    private func getCurrentWeekday() {
        let currentDate = Date()
        let calendar = Calendar.current
        if let dayOfWeek = calendar.dateComponents([.weekday], from: currentDate).weekday {
            self.selectedDay = dayOfWeek - 1
        } else {
            self.selectedDay = 1
        }
    }

    private func animateText() {
        withAnimation(.easeInOut(duration: 2)) {
            showText = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                withAnimation {
                    showMoreText = true
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Exercise.self, configurations: config)
    let mockExercise = Exercise(weekday: 1, orderIndex: 1, name: "Sample Exercise")
    container.mainContext.insert(mockExercise)

    return InitialExerciseBuilderView(onboardingProgress: .constant(50), onboardingGradient: .constant(LinearGradient(colors: [.blue, .red], startPoint: .leading, endPoint: .trailing)))
        .environment(\.modelContext, container.mainContext)
        .ignoresSafeArea()
}
