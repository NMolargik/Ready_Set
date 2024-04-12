//
//  IExerciseSetEntryRepo.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/12/24.
//

import Foundation

protocol IExerciseSetEntryRepo {
    func save(exerciseSetEntry: ExerciseSetEntry)
    func load() -> ExerciseSetEntry
    func remove(exerciseSetEntry: ExerciseSetEntry)
}
