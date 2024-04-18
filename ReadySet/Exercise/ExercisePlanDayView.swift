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
    
    @Binding var selectedDay: Int
    @Binding var isEditing: Bool
    @State private var sortOrder = SortDescriptor(\Exercise.orderIndex)
    
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
                            Button(action: {
                                withAnimation {
                                    // TODO: remove the sets for this exercise
                                    // TODO: remove Exercise
                                    
                                }
                            }, label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundStyle(.white, .red)
                                    .frame(height: 30)
                            })
                            .buttonStyle(.plain)
                        }
                        
                        Spacer()
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



//                    ForEach(exercise.$exerciseSets, id: \.self) { set in
//                        VStack {
//                            if (isEditing) {
//                                HStack (alignment: .top, spacing: 0) {
//                                    Button(action: {
//
//                                    }, label: {
//                                        Image(systemName: "minus.circle.fill")
//                                            .foregroundStyle(.white, .red)
//                                    })
//                                    .frame(height: 20)
//
//                                    HStack (alignment: .top, spacing: 0) {
//                                        VStack {
//                                            Picker("Select Activity Type", selection: set.activityType) {
//                                                Text("Weight").tag("weight")
//                                                Text("Duration").tag("duration")
//                                            }
//                                            .pickerStyle(.segmented)
//                                            .frame(width: 140)
//                                            .padding(.leading, 5)
//                                        }
//
//                                        VStack {
//                                            if set.goalType == .weight {
//                                                // Stepper for repetitions
//                                                Stepper(value: set.repetitions, in: 1...500, step: 10) {
//                                                    Text("\(set.repetitionsToDo) reps")
//                                                        .frame(width: 90)
//                                                }
//
//                                                // Stepper for weight lifted
//                                                Stepper(value: set.weightToLift, in: 1...500, step: 10) {
//                                                    Text("\(set.weightToLift) \(useMetric ? "kg" : "lbs")")
//                                                        .frame(width: 90)
//                                                }
//
//                                            } else if set.goalType == .duration {
//                                                // Stepper for duration (in minutes)
//                                                Stepper(value: set.durationToDo, in: 1...180, step: 1) {
//                                                    Text("\(set.durationToDo / 60) min")
//                                                        .frame(width: 90)
//                                                }
//                                            }
//                                        }
//                                        .frame(width: 180)
//                                    }
//                                    .background {
//                                        Rectangle()
//                                            .foregroundStyle(.clear)
//                                            .cornerRadius(12)
//                                            .frame(height: 30)
//                                    }
//                                }
//                            } else {
//                                HStack (spacing: 0) {
//                                    if (isEditing) {
//                                        HStack {
//                                            if (set.repetitionsToDo != 0) {
//                                                Image(systemName: "repeat")
//
//                                                Text("\(set.repetitionsToDo) reps")
//                                            }
//
//                                            if (set.weightToLift != 0) {
//                                                Image(systemName: "scalemass.fill")
//
//                                                Text("\(set.repetititonsToDo) \(useMetric ? "kg" : "lbs")")
//                                            }
//
//                                            if (set.durationToDo != 0) {
//                                                Text("\(set.durationToDo / 60) minutes")
//                                            }
//                                        }
//                                        .padding(.horizontal, 10)
//                                        .frame(height: 30, alignment: .leading)
//                                        .background {
//                                            Rectangle()
//                                                .foregroundStyle(.orange)
//                                                .cornerRadius(12)
//                                                .frame(height: 30)
//                                        }
//                                    }
//
//                                    Button(action: {
//
//                                    }, label: {
//                                        Image(systemName: "minus.circle.fill")
//                                            .foregroundStyle(.white, .red)
//                                    })
//                                    .frame(height: 20)
//                                    .padding(.leading, 5)
//
//                                    Spacer()
//                                }
//                            }
//                        }
//                    }
