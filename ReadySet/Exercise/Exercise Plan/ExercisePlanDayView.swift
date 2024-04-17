//
//  ExercisePlanDayView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import SwiftUI
import Foundation

struct ExercisePlanDayView: View {
    @State var isEditing: Bool
    @Binding var selectedDay: Int
    
    @State var exerciseEntries: [ExerciseEntry] = []
    @State var exerciseSetEntries: [ExerciseSetEntry] = []
    
    let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        VStack {
            HStack {
                Text(weekDays[selectedDay])
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isEditing.toggle()
                    }
                    
                    //TODO: save stuff
                }, label: {
                    Text(isEditing ? "Save" : "Edit")
                })
                .buttonStyle(.plain)
            }
            
            ForEach($exerciseEntries) { $exerciseEntry in
                ExerciseEntryView(exerciseEntry: $exerciseEntry, exerciseSetEntries: $exerciseSetEntries, selectedDay: $selectedDay, isEditing: $isEditing)
            }
            
            Button(action: {
                withAnimation {
                    //TODO: add a new exerciseEntry
                }
            }, label: {
                Text("Add Exercise")
            })
        }
        .padding(.horizontal, 5)
    }
}

struct ExerciseEntryView: View {
    @Binding var exerciseEntry: ExerciseEntry
    @Binding var exerciseSetEntries: [ExerciseSetEntry]
    @Binding var selectedDay: Int
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack (spacing: 5) {
            HStack (spacing: 5) {
                Text(exerciseEntry.exerciseName)
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
                
            ForEach($exerciseSetEntries.filter({ $0.exerciseID.wrappedValue == exerciseEntry.id.uuidString })) { $exerciseSetEntry in
                ExerciseSetEntryView(exerciseSetEntry: $exerciseSetEntry, isEditing: $isEditing)
            }
        }
    }
}

struct ExerciseSetEntryView: View {
    @AppStorage("useMetric") var useMetric: Bool = false
    
    @Binding var exerciseSetEntry: ExerciseSetEntry
    @Binding var isEditing: Bool
    
    var body: some View{
        VStack {
            if (isEditing) {
                HStack (alignment: .top, spacing: 0) {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundStyle(.white, .red)
                    })
                    .frame(height: 20)
                    
                    HStack (alignment: .top, spacing: 0) {
                        VStack {
                            Picker("Select Activity Type", selection: $exerciseSetEntry.activityType) {
                                Text("Weight").tag("weight")
                                Text("Duration").tag("duration")
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 140)
                            .padding(.leading, 5)
                        }
                        
                        VStack {
                            if exerciseSetEntry.activityType == "weight" {
                                // Stepper for repetitions
                                Stepper(value: $exerciseSetEntry.repetitions, in: 1...500, step: 10) {
                                    Text("\(exerciseSetEntry.repetitions) reps")
                                        .frame(width: 90)
                                }
                                
                                // Stepper for weight lifted
                                Stepper(value: $exerciseSetEntry.weightLifted, in: 1...500, step: 10) {
                                    Text("\(exerciseSetEntry.weightLifted) \(useMetric ? "kg" : "lbs")")
                                        .frame(width: 90)
                                }
                                
                            } else if exerciseSetEntry.activityType == "duration" {
                                // Stepper for duration (in minutes)
                                Stepper(value: $exerciseSetEntry.duration, in: 1...180, step: 1) {
                                    Text("\(exerciseSetEntry.duration / 60) min")
                                        .frame(width: 90)
                                }
                            }
                        }
                        .frame(width: 180)
                    }
                    .background {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .cornerRadius(12)
                            .frame(height: 30)
                    }
                }
            } else {
                HStack (spacing: 0) {
                    if (isEditing) {
                        HStack {
                            if (exerciseSetEntry.repetitions != 0) {
                                Image(systemName: "repeat")
                                
                                Text("\(exerciseSetEntry.repetitions) reps")
                            }
                            
                            if (exerciseSetEntry.weightLifted != 0) {
                                Image(systemName: "scalemass.fill")
                                
                                Text("\(exerciseSetEntry.repetitions) \(useMetric ? "kg" : "lbs")")
                            }
                            
                            if (exerciseSetEntry.duration != 0) {
                                Text("\(exerciseSetEntry.duration / 60) minutes")
                            }
                        }
                        .padding(.horizontal, 10)
                        .frame(height: 30, alignment: .leading)
                        .background {
                            Rectangle()
                                .foregroundStyle(.orange)
                                .cornerRadius(12)
                                .frame(height: 30)
                        }
                    }
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundStyle(.white, .red)
                    })
                    .frame(height: 20)
                    .padding(.leading, 5)
                    
                    Spacer()
                }
            }
        }
    }
}

struct ExercisePlanDayView_Previews: PreviewProvider {
    static var previews: some View {
        let uuid1 = UUID()
        let uuid2 = UUID()
        let uuid3 = UUID()
        
        let exerciseEntries: [ExerciseEntry] = [
            ExerciseEntry(id: uuid1, day: 1, exerciseOrder: 1, exerciseName: "Push-ups"),
            ExerciseEntry(id: uuid2, day: 1, exerciseOrder: 2, exerciseName: "Sit-ups"),
            ExerciseEntry(id: uuid3, day: 1, exerciseOrder: 3, exerciseName: "Squats"),
        ]
        
        let exerciseSetEntries: [ExerciseSetEntry] = [
            ExerciseSetEntry(id: UUID(), exerciseID: uuid1.uuidString, activityType: "weight", setOrder: 1, repetitions: 10, duration: 0, weightLifted: 210),
            ExerciseSetEntry(id: UUID(), exerciseID: uuid1.uuidString, activityType: "weight", setOrder: 2, repetitions: 15, duration: 0, weightLifted: 150),
            ExerciseSetEntry(id: UUID(), exerciseID: uuid2.uuidString, activityType: "duration", setOrder: 1, repetitions: 0, duration: 360, weightLifted: 0),
            ExerciseSetEntry(id: UUID(), exerciseID: uuid3.uuidString, activityType: "weight", setOrder: 1, repetitions: 10, duration: 0, weightLifted: 210),
        ]
        
        return ExercisePlanDayView(exerciseViewModel: ExerciseViewModel(), isEditing: true, selectedDay: .constant(1), exerciseEntries: exerciseEntries, exerciseSetEntries: exerciseSetEntries)
    }
}

import Foundation
import CoreData

@objc(ExerciseEntry)
public class ExerciseEntry: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var day: Int16
    @NSManaged public var exerciseOrder: Int16
    @NSManaged public var exerciseName: String
    
    convenience init(
        id: UUID,
        day: Int16,
        exerciseOrder: Int16,
        exerciseName: String
    ) {
        let entityName = "ExerciseEntry" // Set the entity name here
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: PersistenceController.shared.container.viewContext) else {
            fatalError("Failed to initialize ExerciseEntry entity")
        }
        
        self.init(entity: entity, insertInto: PersistenceController.shared.container.viewContext)
        
        self.id = id
        self.day = day
        self.exerciseOrder = exerciseOrder
        self.exerciseName = exerciseName
    }
}

@objc(ExerciseSetEntry)
public class ExerciseSetEntry: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var exerciseID: String
    @NSManaged public var activityType: String
    @NSManaged public var setOrder: Int16
    @NSManaged public var repetitions: Int16
    @NSManaged public var duration: Int16
    @NSManaged public var weightLifted: Int16

    convenience init(
        id: UUID,
        exerciseID: String,
        activityType: String,
        setOrder: Int16,
        repetitions: Int16,
        duration: Int16,
        weightLifted: Int16
    ) {
        let entity = PersistenceController.shared.getExerciseSetEntry()
        self.init(entity: entity, insertInto: nil)
        
        self.id = id
        self.exerciseID = exerciseID
        self.activityType = activityType
        self.setOrder = setOrder
        self.repetitions = repetitions
        self.duration = duration
        self.weightLifted = weightLifted
    }
}
