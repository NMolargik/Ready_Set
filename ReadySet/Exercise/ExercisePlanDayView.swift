//
//  ExercisePlanDayView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//
// NOTE: THIS FILE HAS NOT BE OPTIMIZED OR COMPARTMENTALIZED YET

import SwiftUI
import SwiftData
import Foundation
import Flow

struct ExercisePlanDayView: View {
    @AppStorage("useMetric") var useMetric: Bool = false
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Exercise.orderIndex)]) var exercises: [Exercise]

    @Binding var isEditing: Bool
    @Binding var isExpanded: Bool
    @State var sortOrder = SortDescriptor(\Exercise.orderIndex)
    
    @State private var selectedSet: ExerciseSet = ExerciseSet()
    @State private var selectedExercise: Exercise = Exercise()

    var selectedDay: Int
    let columns = [
        GridItem(.flexible(minimum: 50, maximum: 100))
    ]

    
    init(selectedDay: Int, isEditing: Binding<Bool>, isExpanded: Binding<Bool>) {
        self.selectedDay = selectedDay
        _exercises = Query(filter: #Predicate {
            return $0.weekday == selectedDay
        }, sort: [SortDescriptor(\Exercise.orderIndex)])
        
        _isEditing = isEditing
        _isExpanded = isExpanded
    }
    
    let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        ScrollView {
            VStack {
                if (exercises.filter({$0.weekday == selectedDay}).count == 0 && !isEditing) {
                    Spacer()
                    
                    Text("Tap The Pencil To Add Exercises")
                        .font(.title2)
                        .foregroundStyle(.baseInvert)
                        .animation(.easeInOut, value: exercises)
                        .transition(.opacity)
                    
                    Spacer()
                }
                
                ForEach(exercises, id: \.self) { exercise in
                    VStack (spacing: 5) {
                        HStack (spacing: 0) {
                            if (isEditing) {
                                Button(action: {
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    withAnimation {
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
                                        .frame(width: 15, height: 15)
                                })
                                .buttonStyle(.plain)
                                
                                Button(action: {
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    withAnimation {
                                        if (selectedExercise.id == exercise.id) {
                                            exercise.name = selectedExercise.name
                                            selectedExercise = Exercise()
                                        } else {
                                            selectedExercise = exercise
                                        }
                                    }
                                }, label: {
                                    if (selectedExercise.id == exercise.id) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.white, .green)
                                            .frame(width: 15, height: 15)

                                    } else {
                                        Image(systemName: "ellipsis.rectangle")
                                            .foregroundStyle(.white, .green)
                                            .frame(width: 15, height: 15)
                                            
                                    }
                                })
                                .padding(.leading, 20)
                                .buttonStyle(.plain)
                            }

                            if (exercise.id == selectedExercise.id && isEditing) {
                                TextField("Exercise Name", text: $selectedExercise.name)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .onChange(of: selectedExercise.name) {
                                        withAnimation {
                                            exercise.name = selectedExercise.name
                                        }
                                    }
                                    .frame(maxWidth: 200, alignment: .leading)
                                    .scaleEffect(0.9)
                                
                            } else {
                                Text(exercise.name)
                                    .padding(.horizontal, 5)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: 200, alignment: .leading)
                                    .foregroundStyle(.baseInvert)
                                    .truncationMode(.tail)
                            }
                            
                            Spacer()
                            
                            if (isEditing) {
                                Button(action: {
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    withAnimation {
                                        let newSet = ExerciseSet(goalType: .duration, repetitionsToDo: 0, durationToDo: 30, weightToLift: 30)
                                        exercise.exerciseSets.append(newSet)
                                        modelContext.insert(newSet)
                                        do {
                                            try modelContext.save()
                                        } catch {
                                            print("\(error.localizedDescription)")
                                        }
                                        selectedSet = newSet
                                    }
                                }, label: {
                                    HStack (spacing: 0) {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundStyle(.white, .green)
                                            .frame(height: 15)
                                        
                                        Text("Set")
                                            .bold()
                                            .foregroundStyle(.baseInvert)
                                            .padding(.horizontal, 2)
                                            .padding(.vertical, 2)
                                            .shadow(radius: 5)
                                    }
                                })
                                .buttonStyle(.plain)
                            }
                        }
                        .animation(.easeInOut, value: exercises.count)
                        .transition(.move(edge: .leading))
                        
                        VStack (spacing: 0) {
                            if (exercise.exerciseSets.count == 0 ) {
                                HStack {
                                    Text("No sets added yet")
                                        .font(.caption)
                                        .foregroundStyle(.baseInvert)
                                        .animation(.easeInOut, value: exercises)
                                        .transition(.opacity)
                                    
                                    Spacer()
                                }
                                .padding(.leading)
                            }
                            
                            if (isEditing) {
                                ForEach(exercise.exerciseSets, id: \.self) { set in
                                    HStack {
                                        ExerciseSetEditor(set: set)
                                            .padding(.bottom, 4)
                                        
                                        Button(action: {
                                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                            withAnimation {
                                                exercise.exerciseSets.remove(at: exercise.exerciseSets.firstIndex(of: set) ?? 0)
                                                modelContext.delete(set)
                                                
                                                do {
                                                    try modelContext.save()
                                                } catch {
                                                    print("\(error.localizedDescription)")
                                                }
                                            }
                                        }, label: {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundStyle(.white, .red)
                                                .frame(width: 15, height: 15)
                                        })
                                        .buttonStyle(.plain)
                                    }
                                }
                            } else {
                                HFlow(itemSpacing: 4, rowSpacing: 6) {
                                    ForEach(exercise.exerciseSets, id: \.self) { set in
                                        if (selectedSet.id == set.id) {
                                            HStack {
                                                VStack {
                                                    if selectedSet.goalType == .duration {
                                                        Stepper(value: Binding(
                                                            get: { selectedSet.durationToDo },
                                                            set: { selectedSet.durationToDo = $0 }
                                                        ), label: {
                                                            HStack {
                                                                Image(systemName: "stopwatch")
                                                                    .foregroundStyle(.greenEnd)
                                                                Text("\(selectedSet.durationToDo)")
                                                                    .bold()
                                                                    .foregroundStyle(.baseInvert)
                                                            }
                                                        })
                                                    } else {
                                                        Stepper(value: Binding(
                                                            get: { selectedSet.weightToLift },
                                                            set: { selectedSet.weightToLift = $0 }
                                                        ), label: {
                                                            HStack {
                                                                Image(systemName: "scalemass")
                                                                    .foregroundStyle(.baseInvert)
                                                                Text("\(selectedSet.weightToLift)")
                                                                    .bold()
                                                                    .foregroundStyle(.baseInvert)
                                                            }
                                                        })
                                                        
                                                        Stepper(value: Binding(
                                                            get: { selectedSet.repetitionsToDo },
                                                            set: { selectedSet.repetitionsToDo = $0 }
                                                        ), label: {
                                                            HStack {
                                                                Image(systemName: "repeat")
                                                                    .foregroundStyle(.orangeEnd)
                                                                Text("\(selectedSet.repetitionsToDo)")
                                                                    .bold()
                                                                    .foregroundStyle(.baseInvert)
                                                            }
                                                            
                                                        })
                                                    }
                                                }
                                                .frame(width: 200, alignment: .leading)
                                                
                                                Spacer()
                                                
                                                Button(action: {
                                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                                    withAnimation {
                                                        selectedSet = ExerciseSet()
                                                    }
                                                }, label: {
                                                    Text("Save")
                                                        .foregroundStyle(.baseInvert)
                                                        .bold()
                                                        .padding(10)
                                                })
                                                .buttonStyle(.plain)
                                                .background {
                                                    ZStack {
                                                        Rectangle()
                                                            .cornerRadius(5)
                                                            .foregroundStyle(.blue)
                                                            .shadow(radius: 5)
                                                    }
                                                    .compositingGroup()
                                                }
                                                .padding(.trailing)
                                            }
                                            .frame(width: 300)
                                            .padding(3)
                                            .background {
                                                ZStack {
                                                    Rectangle()
                                                        .foregroundStyle(.thickMaterial)
                                                        .shadow(radius: 5)
                                                    Rectangle()
                                                        .blendMode(.destinationOut)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .stroke(.baseInvert, lineWidth: 1)
                                                        )
                                                }
                                                .compositingGroup()
                                            }
                                            .animation(.easeInOut, value: selectedSet)
                                            .transition(.scale(scale: 0.1, anchor: .leading))
                                            
                                        } else {
                                            
                                            
                                            HStack (alignment: .center) {
                                                Button(action: {
                                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                                    withAnimation {
                                                        selectedSet = set
                                                    }
                                                }, label: {
                                                    HStack {
                                                        if (set.goalType == .duration) {
                                                            Image(systemName: "stopwatch")
                                                                .foregroundStyle(.greenEnd)
                                                            
                                                            Text(set.durationToDo.description)
                                                                .foregroundStyle(.base)
                                                        } else {
                                                            Image(systemName: "scalemass")
                                                                .foregroundStyle(.baseAccent)
                                                            
                                                            Text(set.weightToLift.description)
                                                                .foregroundStyle(.base)
                                                            
                                                            Image(systemName: "repeat")
                                                                .foregroundStyle(.orangeEnd)
                                                            
                                                            Text(set.repetitionsToDo.description)
                                                                .foregroundStyle(.base)
                                                        }
                                                    }
                                                    .lineLimit(1)
                                                    .padding(3)
                                                    .background {
                                                        Rectangle()
                                                            .foregroundStyle(.baseInvert)
                                                            .cornerRadius(5)
                                                        
                                                    }
                                                })
                                                .buttonStyle(.plain)
                                            }
                                            
                                            .animation(.easeInOut, value: exercises.count)
                                            .transition(.move(edge: .leading).combined(with: .opacity))
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 5)
                    }
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
                                    .foregroundStyle(.white, .green)
                                    .frame(height: 15)
                                
                            }
                        })
                        .buttonStyle(.plain)
                        
                        Spacer()
                    }
                    .animation(.easeInOut, value: exercises.count)
                    .transition(.move(edge: .leading))
                        
                }
            }
            .padding(.horizontal, 5)
        }
        .scrollDisabled(!isEditing && !isExpanded)
        .onChange(of: isEditing) {
            if (!isEditing) {
                selectedSet = ExerciseSet()
                selectedExercise = Exercise()
            }
        }
    }
    
    func addExercise(currentLength: Int, weekday: Int) {
        let exercise = Exercise(weekday: weekday, orderIndex: currentLength + 1)
        modelContext.insert(exercise)
        selectedExercise = exercise
    }
}
