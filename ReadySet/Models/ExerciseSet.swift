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
    let id: UUID
    var goalType: GoalType
    var repetitionsToDo: Int
    var durationToDo: Int
    var weightToLift: Int
    let timestamp: Date

    init(goalType: GoalType = .weight, repetitionsToDo: Int = 0, durationToDo: Int = 0, weightToLift: Int = 0, timestamp: Date = .now) {
        self.id = UUID()
        self.goalType = goalType
        self.repetitionsToDo = repetitionsToDo
        self.durationToDo = durationToDo
        self.weightToLift = weightToLift
        self.timestamp = timestamp
    }
}

