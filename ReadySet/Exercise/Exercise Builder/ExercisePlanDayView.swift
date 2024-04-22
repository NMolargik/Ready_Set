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
    @AppStorage("useMetric") var useMetric: Bool = false
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
                if (exercises.count == 0 && !isEditing) {
                    Spacer()
                    
                    Text("Tap The Pencil To Add Exercises")
                        .bold()
                        .font(.title3)
                        .foregroundStyle(.baseInvert)
                        .animation(.easeInOut, value: exercises)
                        .transition(.opacity)
                    
                    Spacer()
                }
                
                ForEach(exercises, id: \.self) { exercise in
                    ExerciseEntryView(exercise: exercise, isEditing: $isEditing, selectedExercise: $selectedExercise, selectedSet: $selectedSet, keyboardShown: $keyboardShown)
                        .id(exercise.id)
                }
                
                if (isEditing) {
                    HStack {
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            withAnimation {
                                addExercise(currentLength: exercises.count, weekday: selectedDay)
                            }
                        }, label: {
                            HStack (spacing: 0) {
                                Text("Exercise")
                                    .bold()
                                    .foregroundStyle(.baseInvert)
                                    .padding(.horizontal, 2)
                                    .padding(.vertical, 2)
                                    .shadow(radius: 5)
                                
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle(LinearGradient(colors: [.greenStart, .greenEnd], startPoint: .leading, endPoint: .trailing))
                                    .frame(height: 15)
                                
                            }
                        })
                        .buttonStyle(.plain)
                        
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
            .padding(.vertical, 30)
        }
        .scrollDisabled(!isEditing && !isExpanded)
        .onChange(of: isEditing) {
            if (!isEditing) {
                selectedExercise = Exercise()
                selectedSet = ""
            }
        }
    }
    
    private func addExercise(currentLength: Int, weekday: Int) {
        let exercise = Exercise(weekday: weekday, orderIndex: currentLength + 1)
        modelContext.insert(exercise)
        selectedExercise = exercise
    }
}
