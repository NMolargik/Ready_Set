//
//  IExerciseEntryRepo.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/17/24.
//

import Foundation

protocol IExerciseEntryRepo {
    func save(exerciseEntry: ExerciseEntry)
    func loadAll() -> [ExerciseEntry]?
    func remove(exerciseEntry: ExerciseEntry)
}
