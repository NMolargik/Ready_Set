//
//  SwiftUIView.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/18/24.
//

import SwiftUI

struct ExerciseSetEditor: View {
    @Bindable var set: ExerciseSet
    var goalType: GoalType
    
    init(set: ExerciseSet) {
        self.set = set
        self.goalType = set.goalType
    }

    var body: some View {
        Picker("Type", selection: $set.goalType) {
            Text("Duration").tag(GoalType.duration)
            Text("Repitition/Weight").tag(GoalType.weight)
        }
        VStack {
            if ($set.wrappedValue.goalType == .duration) {
                Stepper("D", value: self.$set.durationToDo)
            } else {
                Stepper("R", value: self.$set.repetitionsToDo)
                Stepper("W", value: self.$set.weightToLift)
            }
        }
    }
}

