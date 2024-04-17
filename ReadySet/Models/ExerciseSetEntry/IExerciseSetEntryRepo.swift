//
//  IExerciseSetEntryRepo.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/12/24.
//
//  This protocol constrains all implementations of the ExerciseSetEntryRepo type


import Foundation

protocol IExerciseSetEntryRepo {
    func save(exerciseSetEntry: ExerciseSetEntry)
    func loadAll() -> [ExerciseSetEntry]?
    func remove(exerciseSetEntry: ExerciseSetEntry)
}
