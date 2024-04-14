//
//  ExerciseViewModel.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import Foundation

class ExerciseViewModel: ObservableObject {
    // Add the repo for getting all sets
    
    
    @Published var exerciseSetMaster: [ExerciseSet] = [ExerciseSet]()
    @Published var waterGoal: Int = 0
    @Published var calorieGoal: Int = 0
    
    @Published var formComplete: Bool = false
    
    let exerciseSetRepo = ExerciseSetRepo()
    
    init() {
        exerciseSetMaster = exerciseSetRepo.loadAll()
    }
    
    
    
    
}
