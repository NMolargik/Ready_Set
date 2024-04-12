//
//  ExerciseSetController.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/12/24.
//

import Foundation
import UIKit

class ExerciseSetController: ObservableObject {
    @Published private(set) var exerciseSet: ExerciseSet?
    
    let exerciseSetRepo: IExerciseSetRepo
    
    init(exerciseSetRepo: IExerciseSetRepo) {
        self.exerciseSetRepo = exerciseSetRepo
    }
    
    public func save(exerciseSet: ExerciseSet) {
        exerciseSetRepo.save(exerciseSet: exerciseSet)
    }
}
