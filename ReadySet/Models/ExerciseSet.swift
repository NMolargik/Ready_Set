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
    var lastRepetitionsRecorded: Int
    var lastDurationRecorded: Int
    var lastWeightRecorded: Int

    init(goalType: GoalType = .weight, repetitionsToDo: Int = 0, durationToDo: Int = 0, weightToLift: Int = 0, lastRepetitionsRecorded: Int = 0, lastDurationRecorded: Int = 0, lastWeightRecorded: Int = 0) {
        self.goalType = goalType
        self.repetitionsToDo = repetitionsToDo
        self.durationToDo = durationToDo
        self.weightToLift = weightToLift
        self.lastRepetitionsRecorded = lastRepetitionsRecorded
        self.lastDurationRecorded = lastDurationRecorded
        self.lastWeightRecorded = lastWeightRecorded
    }
}

