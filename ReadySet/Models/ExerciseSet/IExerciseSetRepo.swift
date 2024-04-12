//
//  IExerciseSetRepo.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/12/24.
//

import Foundation

protocol IExerciseSetRepo {
    func save(exerciseSet: ExerciseSet)
    func load() -> ExerciseSet
    func remove(exerciseSet: ExerciseSet)
}
