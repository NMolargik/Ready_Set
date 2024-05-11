//
//  ExercisePlanDayView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import SwiftUI
import SwiftData

struct ExercisePlanDayView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("useMetric", store: UserDefaults(suiteName: Bundle.main.groupID)) var useMetric: Bool = false
    @FocusState private var keyboardShown: Bool

    @Binding var exercises: [Exercise]
    @Binding var isEditing: Bool
    @Binding var isExpanded: Bool
    @State var sortOrder = SortDescriptor(\Exercise.orderIndex)
    @State private var selectedExercise: Exercise = Exercise()
    @State private var selectedSet: String = ""

    var selectedDay: Int
    let columns = [
        GridItem(.flexible(minimum: 50, maximum: 100))
    ]
    
    let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(exercises, id: \.self) { exercise in
                    ExerciseEntryView(exercise: exercise, isEditing: $isEditing, selectedExercise: $selectedExercise, selectedSet: $selectedSet, keyboardShown: $keyboardShown)
                        .id(exercise.id)
                }
                
                if (isEditing) {
                    HStack {
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            withAnimation {
                                let exercise = Exercise(weekday: selectedDay, orderIndex: exercises.count + 1)
                                modelContext.insert(exercise)
                                selectedExercise = exercise
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
                                .foregroundStyle(ExerciseTabItem().gradient)
                                .shadow(radius: 5)
                        }
                        .padding(.leading, 5)
                        
                        Spacer()
                    }
                    .animation(.easeInOut, value: exercises.count)
                    .transition(.move(edge: .leading))
                    
                }
                
                if (isEditing) {
                    Spacer(minLength: 400)
                }
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 30)
        }
        .scrollDisabled(!isEditing && !isExpanded)
        .onChange(of: isEditing) {
            if (!isEditing) {
                selectedExercise = Exercise()
                selectedSet = ""
            }
        }
    }
}
