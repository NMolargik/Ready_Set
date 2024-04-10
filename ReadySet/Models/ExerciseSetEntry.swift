//
//  ExerciseEntrySet.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/10/24.
//

import Foundation

struct ExerciseSetEntry {
    let set: UUID
    let timestamp: Date
    let reps: Int?
    let duration: Int?
    let weight: Int?
}
