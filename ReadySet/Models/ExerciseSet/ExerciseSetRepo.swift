//
//  ExerciseSetRepo.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/12/24.
//

/*
 This repository controls CRUD for the ExerciseSet table in CoreData.
 It should be expanded upon to handle query parameters / predicates
 by manipulating the fetchRequest variable and following the same pattern
 as the load() method
*/

import Foundation

struct ExerciseSetRepo: IExerciseSetRepo {
    let viewContext = PersistenceController.shared.container.viewContext
    
    // Save a new exerciseSet record to the table
    func save(exerciseSet: ExerciseSet) {
        viewContext.insert(exerciseSet)
        
        do {
            try viewContext.save()
            print("ExerciseSet saved successfully.")
        } catch {
            print("Error saving context after insert: \(error.localizedDescription)")
        }
    }
    
    // Load the first exerciseSet record from the table
    func load() -> ExerciseSet {
        let fetchRequest = ExerciseSet.fetchRequest()
        
        do {
            let user = try viewContext.fetch(fetchRequest)
            return user.first as? ExerciseSet ?? ExerciseSet()
        } catch {
            print("Error loading exerciseSet: \(error.localizedDescription)")
            return ExerciseSet()
        }
    }
    
    // Remove a particular exerciseSet record from the table
    func remove(exerciseSet: ExerciseSet) {
        viewContext.delete(exerciseSet)
        
        do {
            try viewContext.save()
            print("ExerciseSet successfully removed.")
        } catch {
            print("Error saving context after deletion: \(error.localizedDescription)")
        }
    }
}
