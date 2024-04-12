//
//  ExerciseSetEntryController.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/12/24.
//

import Foundation
import UIKit

class ExerciseSetEntryController: ObservableObject {
    @Published private(set) var exerciseSetEntry: ExerciseSetEntry?
    
    let exerciseSetEntryRepo: IExerciseSetEntryRepo
    
    init(exerciseSetEntryRepo: IExerciseSetEntryRepo) {
        self.exerciseSetEntryRepo = exerciseSetEntryRepo
    }
    
    public func save(exerciseSetEntry: ExerciseSetEntry) {
        exerciseSetEntryRepo.save(exerciseSetEntry: exerciseSetEntry)
    }
}
