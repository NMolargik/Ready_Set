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

    init(goalType: GoalType = .weight, repetitionsToDo: Int = 5, durationToDo: Int = 10, weightToLift: Int = 100, timestamp: Date = .now) {
        self.id = UUID()
        self.goalType = goalType
        self.repetitionsToDo = repetitionsToDo
        self.durationToDo = durationToDo
        self.weightToLift = weightToLift
        self.timestamp = timestamp
    }
}
