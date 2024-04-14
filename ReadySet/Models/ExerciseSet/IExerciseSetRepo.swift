//
//  IExerciseSetRepo.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/12/24.
//
//  This protocol constrains all implementations of the ExerciseSetRepo type


import Foundation

protocol IExerciseSetRepo {
    func save(exerciseSet: ExerciseSet)
    func loadAll() -> [ExerciseSet]
    func remove(exerciseSet: ExerciseSet)
}
