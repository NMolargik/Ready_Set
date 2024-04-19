//
//  SwiftUIView.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/18/24.
//

import SwiftUI

struct ExerciseSetEditor: View {
    @Bindable var exerciseSet: ExerciseSet
    var goalType: GoalType
    
    init(exerciseSet: ExerciseSet) {
        self.exerciseSet = exerciseSet
        self.goalType = exerciseSet.goalType
    }

    var body: some View {
        Picker("Type", selection: $exerciseSet.goalType) {
            Text("Duration").tag(GoalType.duration)
            Text("Repitition/Weight").tag(GoalType.weight)
        }
        VStack {
            if ($exerciseSet.wrappedValue.goalType == .duration) {
                Stepper("D", value: self.$exerciseSet.durationToDo)
            } else {
                Stepper("R", value: self.$exerciseSet.repetitionsToDo)
                Stepper("W", value: self.$exerciseSet.weightToLift)
            }
        }
    }
}

