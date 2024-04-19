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
    @FocusState private var keyboardShown: Bool
    
    @Query(sort: [SortDescriptor(\Exercise.orderIndex)]) var exercises: [Exercise]

    @Binding var isEditing: Bool
    @Binding var isExpanded: Bool
    @State var sortOrder = SortDescriptor(\Exercise.orderIndex)
    @State private var selectedExercise: Exercise = Exercise()
    @State private var selectedSet: ExerciseSet = ExerciseSet()

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
                        .animation(.easeInOut, value: exercises)
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
                
                
                if (keyboardShown) {
                    Spacer(minLength: 400)
                }
            }
            .padding(.horizontal, 5)
        }
        .scrollDisabled(!isEditing && !isExpanded)
        .onChange(of: isEditing) {
            if (!isEditing) {
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


struct ExerciseEntryView: View {
    @Environment(\.modelContext) var modelContext
    @State var exercise: Exercise
    @Binding var isEditing: Bool
    @Binding var selectedExercise: Exercise
    @Binding var selectedSet: ExerciseSet
    
    var keyboardShown: FocusState<Bool>.Binding
    

    var body: some View {
        VStack (spacing: 5) {
            ExerciseEntryHeaderView(exercise: exercise, isEditing: $isEditing, selectedExercise: $selectedExercise, selectedSet: $selectedSet, keyboardShown: keyboardShown)
            
            VStack (spacing: 0) {
                if (exercise.exerciseSets.count == 0 ) {
                    HStack {
                        Text("No sets added yet")
                            .font(.caption)
                            .foregroundStyle(.baseInvert)
                            .transition(.opacity)
                        
                        Spacer()
                    }
                    .padding(.leading)
                }
                
                if (isEditing) {
                    ForEach(exercise.exerciseSets.sorted(by: { $0.timestamp < $1.timestamp })) { set in
                        HStack {
                            ExerciseSetEditor(set: set)
                                .padding(.bottom, 4)
                            
                            Button(action: {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                withAnimation {
                                    exercise.exerciseSets.remove(at: exercise.exerciseSets.firstIndex(of: set) ?? 0)
                                    modelContext.delete(set)
                                }
                            }, label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundStyle(LinearGradient(colors: [.orangeStart, .orangeEnd], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 15, height: 15)
                            })
                            .buttonStyle(.plain)
                            .shadow(radius: 5)
                        }
                    }
                } else {
                    ExerciseSetGridView(exercise: exercise, isEditing: $isEditing)
                }
            }
            .padding(.bottom, 5)
            .onChange(of: isEditing) {
                if (!isEditing) {
                    selectedSet = ExerciseSet()
                }
            }
        }
    }
}

struct ExerciseEntryHeaderView: View {
    @Environment(\.modelContext) var modelContext
    
    @State var exercise: Exercise
    @Binding var isEditing: Bool
    @Binding var selectedExercise: Exercise
    @Binding var selectedSet: ExerciseSet
    var keyboardShown: FocusState<Bool>.Binding
    
    var body: some View {
        HStack (spacing: 0) {
            if (isEditing) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation {
                        modelContext.delete(exercise)
                    }
                }, label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundStyle(LinearGradient(colors: [.orangeStart, .orangeEnd], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 15, height: 15)
                })
                .buttonStyle(.plain)
                .shadow(radius: 5)
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
                    .focused(keyboardShown)
                
            } else {
                Text(exercise.name)
                    .lineLimit(1)
                    .padding(.horizontal, 5)
                    .fontWeight(.semibold)
                    .foregroundStyle(.baseInvert)
                    .truncationMode(.tail)
            }
            
            if (isEditing) {
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
                            .foregroundStyle(LinearGradient(colors: [.greenStart, .greenEnd], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 15, height: 15)
                        
                    } else {
                        Image(systemName: "ellipsis.rectangle")
                            .foregroundStyle(LinearGradient(colors: [.greenStart, .greenEnd], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 15, height: 15)
                        
                    }
                })
                .shadow(radius: 5)
                .padding(.leading, 20)
                .buttonStyle(.plain)
                .id(exercise.id.uuidString)
            }
            
            Spacer()
            
            if (isEditing) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation {
                        let newSet = ExerciseSet(goalType: .weight, repetitionsToDo: 5, durationToDo: 10, weightToLift: 100)
                        exercise.exerciseSets.append(newSet)
                        modelContext.insert(newSet)
                        selectedSet = newSet
                    }
                }, label: {
                    HStack (spacing: 0) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(LinearGradient(colors: [.greenStart, .greenEnd], startPoint: .leading, endPoint: .trailing))
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
        .transition(.move(edge: .leading))
    }
}

struct ExerciseSetGridView: View {
    @State var exercise: Exercise
    @Binding var isEditing: Bool
    
    @State private var selectedSet: ExerciseSet = ExerciseSet()
    
    var body: some View {
        HFlow(itemSpacing: 4, rowSpacing: 6) {
            ForEach(exercise.exerciseSets, id: \.self) { set in
                if (selectedSet.id == set.id) {
                    ExerciseSetRecordingView(selectedSet: $selectedSet)
                    
                } else {
                    ExerciseSetCapsuleView(set: set, selectedSet: $selectedSet)
                }
            }
        }
    }
}


struct ExerciseSetCapsuleView: View {
    @State var set: ExerciseSet
    @Binding var selectedSet: ExerciseSet
    
    var body: some View {
        HStack (alignment: .center) {
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                withAnimation {
                    selectedSet = set
                }
            }, label: {
                HStack {
                    if (set.goalType == .duration) {
                        Image(systemName: "stopwatch.fill")
                            .foregroundStyle(LinearGradient(colors: [.purpleStart, .purpleEnd], startPoint: .leading, endPoint: .trailing))
                        
                        Text(set.durationToDo.description)
                            .foregroundStyle(.base)
                    } else {
                        Image(systemName: "scalemass.fill")
                            .foregroundStyle(LinearGradient(colors: [.blueStart, .blueEnd], startPoint: .leading, endPoint: .trailing))
                        
                        Text(set.weightToLift.description)
                            .foregroundStyle(.base)
                        
                        Image(systemName: "repeat")
                            .foregroundStyle(LinearGradient(colors: [.orangeStart, .orangeEnd], startPoint: .leading, endPoint: .trailing))
                        
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
        .transition(.move(edge: .leading).combined(with: .opacity))
    }
}

struct ExerciseSetRecordingView: View {
    @Binding var selectedSet: ExerciseSet

    var body: some View {
        HStack {
            VStack(spacing: 0) {
                if selectedSet.goalType == .duration {
                    CustomStepperView(value: $selectedSet.durationToDo, step: 5, iconName: "stopwatch.fill", colors: [.purpleStart, .purpleEnd])
                    
                } else {
                    CustomStepperView(value: $selectedSet.weightToLift, step: 5, iconName: "scalemass.fill", colors: [.blueStart, .blueEnd])
                    
                    CustomStepperView(value: $selectedSet.repetitionsToDo, step: 1, iconName: "repeat", colors: [.orangeStart, .orangeEnd])
                }
            }
            
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                withAnimation {
                    selectedSet = ExerciseSet()
                }
            }, label: {
                Text("Save")
                    .foregroundStyle(LinearGradient(colors: [.greenStart, .greenEnd], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .bold()
            })
            .buttonStyle(.plain)
            .padding(.horizontal, 5)
        }
        .padding(.vertical, 3)
        .padding(.horizontal, 5)
        .background(ZStack {
            Rectangle()
                .foregroundStyle(.thickMaterial)
                .shadow(radius: 5)
            Rectangle()
                .blendMode(.destinationOut)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.baseInvert, lineWidth: 1)
                )
        }
        .compositingGroup())
        .animation(.easeInOut, value: selectedSet)
        .padding(.leading)
    }
}

struct CustomStepperView: View {
    @Binding var value: Int
    var step: Int
    var iconName: String
    var colors: [Color]
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Image(systemName: iconName)
                .foregroundStyle(LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
                .frame(width: 20)
            
            Text("\(value)")
                .bold()
                .foregroundStyle(.baseInvert)
                .frame(width: 50)
            
            Stepper(value: $value, step: step, label: {EmptyView()})
                .labelsHidden()
                .colorMultiply(colors[1])
        }
        .onChange(of: value) {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        }
    }
}
