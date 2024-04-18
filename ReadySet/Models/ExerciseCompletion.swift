//
//  ExerciseCompletion.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/10/24.
//

import Foundation
import SwiftData

@Model
class ExerciseCompletion {
    var timestamp: Date
    var goalAmountRecorded: Int
    
    init(timestamp: Date = .now, goalAmountRecorded: Int = 0) {
        self.timestamp = timestamp
        self.goalAmountRecorded = goalAmountRecorded
    }
}
