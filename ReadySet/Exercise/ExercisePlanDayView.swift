//
//  ExercisePlanDayView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import SwiftUI
import SwiftData
import Foundation

struct ExercisePlanDayView: View {
    @AppStorage("useMetric") var useMetric: Bool = false
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Exercise.orderIndex)]) var exercises: [Exercise]

    @Binding var isEditing: Bool
    @State private var sortOrder = SortDescriptor(\Exercise.orderIndex)

    var selectedDay: Int
    @State var durAmount: Int = 0
    @State var susAmount: Int = 0

    init(selectedDay: Int, isEditing: Binding<Bool>) {
        self.selectedDay = selectedDay
        _exercises = Query(filter: #Predicate {
            return $0.weekday == selectedDay
        }, sort: [SortDescriptor(\Exercise.orderIndex)])
        
        _isEditing = isEditing
    }
    
    let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        VStack {
            ForEach(exercises, id: \.self) { exercise in
                VStack (spacing: 5) {
                    HStack (spacing: 5) {
                        Text(exercise.name)
                            .padding(.horizontal, 10)
                            .fontWeight(.semibold)
                            .frame(width: 300, alignment: .leading)
                            .foregroundStyle(.base)
                            .background {
                                Rectangle()
                                    .foregroundStyle(.greenEnd)
                                    .cornerRadius(12)
                                    .frame(height: 30)
                            }

                        if (isEditing) {
                            //Stepper("Buh", value: $amount)
                            VStack {
                                Button(action: {
                                    withAnimation {
                                        // TODO: remove the sets for this exercise
                                        // TODO: remove Exercise
                                        print("\(exercise.name) - \(exercise.id.id) - \(exercise.exerciseSets.count)")
                                        let es = ExerciseSet(goalType: .duration, repetitionsToDo: 0, durationToDo: 30, weightToLift: 30, lastRepetitionsRecorded: 0, lastDurationRecorded: 0, lastWeightRecorded: 0)
                                        exercise.exerciseSets.append(es)
                                        modelContext.insert(es)
                                        modelContext.insert(exercise)
                                        do {
                                            try modelContext.save()
                                        } catch {
                                            print("\(error.localizedDescription)")
                                        }
                                    }
                                }, label: {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(.green, .white)
                                })
                                Button(action: {
                                    withAnimation {
                                        // TODO: remove the sets for this exercise
                                        // TODO: remove Exercise
                                        print("\(exercise.name) - \(exercise.id.id)")
                                        modelContext.delete(exercise)
                                        do {
                                            try modelContext.save()
                                        } catch {
                                            print("\(error.localizedDescription)")
                                        }
                                    }
                                }, label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundStyle(.white, .red)
                                        .frame(height: 20)
                                })
                                .buttonStyle(.plain)
                            }
                        }

                        Spacer()
                    }
                    ForEach(exercise.exerciseSets, id: \.self) { set in
                        HStack {
                            Text("\($durAmount.wrappedValue) - \(set.repetitionsToDo) - \(set.weightToLift)")
                                .frame(height: 20)
                            if (isEditing) {
                                VStack {
                                    Stepper("Duration", value: $durAmount)
                                    Stepper("Repititions", value: $susAmount)
                                }
                                VStack {
                                    Button(action: {
                                        withAnimation {
                                            print("\(set.id.id)")
                                            exercise.exerciseSets.remove(at: exercise.exerciseSets.firstIndex(of: set) ?? 0)
                                            modelContext.delete(set)
                                        }
                                    }, label: {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundStyle(.white, .red)
                                            .frame(height: 20)
                                    })
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
            }
            
            Button(action: {
                withAnimation {
                    addExercise(currentLength: exercises.count, weekday: selectedDay)
                }
            }, label: {
                Text("Add Exercise")
            })
        }
        .padding(.horizontal, 5)
    }
    
    func addExercise(currentLength: Int, weekday: Int) {
        let exercise = Exercise(weekday: weekday, orderIndex: currentLength + 1)
        modelContext.insert(exercise)
    }

}
