//
//  ExerciseSetRecordEntryController.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/12/24.
//

import Foundation
import UIKit

class ExerciseSetRecordEntryController: ObservableObject {
    @Published private(set) var exerciseSetRecordEntry: ExerciseSetRecordEntry?
    
    let exerciseSetRecordEntryRepo: IExerciseSetRecordEntryRepo
    
    init(exerciseSetRecordEntryRepo: IExerciseSetRecordEntryRepo) {
        self.exerciseSetRecordEntryRepo = exerciseSetRecordEntryRepo
    }
    
    public func save(exerciseSetRecordEntry: ExerciseSetRecordEntry) {
        exerciseSetRecordEntryRepo.save(exerciseSetRecordEntry: exerciseSetRecordEntry)
    }
}
