//
//  IExerciseSetRecordEntryRepo.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/12/24.
//
//  This protocol constrains all implementations of the ExerciseSetEntryRepo type


import Foundation

protocol IExerciseSetRecordEntryRepo {
    func save(exerciseSetRecordEntry: ExerciseSetRecordEntry)
    func load() -> ExerciseSetRecordEntry
    func remove(exerciseSetRecordEntry: ExerciseSetRecordEntry)
}
