//
//  ExerciseSet.swift
//  ReadySet
//
//  Created by Nicholas Molargik on 4/10/24.
//

import Foundation
import SwiftData

@Model
class ExerciseSet: Identifiable {
    var goalType: GoalType
    var repetitionsToDo: Int
    var durationToDo: Int
    var weightToLift: Int
    @Relationship(deleteRule: .cascade) var exerciseCompletions = [ExerciseCompletion]()

    init(goalType: GoalType = .weight, repetitionsToDo: Int = 0, durationToDo: Int = 0, weightToLift: Int = 0) {
        self.goalType = goalType
        self.repetitionsToDo = repetitionsToDo
        self.durationToDo = durationToDo
        self.weightToLift = weightToLift
    }
}

