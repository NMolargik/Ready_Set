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
                        HStack(alignment: .center) {
                            Group {
                                Button(action: {
                                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                                    withAnimation {
                                        selectedDay -= 1
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
                                .disabled(selectedDay == 0)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                                .opacity(selectedDay == 0 ? 0 : 1)

                                Spacer()

                                Text(exerciseViewModel.weekDays[selectedDay])
                                    .fontWeight(.semibold)
                                    .font(.title)
                                    .foregroundStyle(.baseInvert.gradient)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .padding(.vertical, 5)

                                Spacer()

                                Button(action: {
                                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                                    withAnimation {
                                        selectedDay += 1
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
                                .disabled(selectedDay == 6)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                                .opacity(selectedDay == 6 ? 0 : 1)
                            }
                        }
                        .padding(.horizontal)

                        ExercisePlanDayView(exerciseViewModel: exerciseViewModel, exercises: .constant(filteredExercises), selectedDay: selectedDay, hideNudge: true)
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
