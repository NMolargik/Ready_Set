//
//  ExerciseEntryController.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/17/24.
//

import Foundation
import UIKit

class ExerciseEntryController: ObservableObject {
    @Published private(set) var exerciseEntry: ExerciseEntry?
    
    let exerciseEntryRepo: IExerciseEntryRepo
    
    init(exerciseEntryRepo: IExerciseEntryRepo) {
        self.exerciseEntryRepo = exerciseEntryRepo
    }
    
    public func save(exerciseEntry: ExerciseEntry) {
        exerciseEntryRepo.save(exerciseEntry: exerciseEntry)
    }
}
