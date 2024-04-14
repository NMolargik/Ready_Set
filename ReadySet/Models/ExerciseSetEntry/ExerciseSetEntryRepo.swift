//
//  ExerciseSetEntryRepo.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/12/24.
//

/*
 This repository controls CRUD for the ExerciseSetEntry table in CoreData.
 It should be expanded upon to handle query parameters / predicates
 by manipulating the fetchRequest variable and following the same pattern
 as the load() method
*/

import Foundation

struct ExerciseSetEntryRepo: IExerciseSetEntryRepo {
    let viewContext = PersistenceController.shared.container.viewContext
    
    // Insert a new exerciseSetEntry record
    func save(exerciseSetEntry: ExerciseSetEntry) {
        viewContext.insert(exerciseSetEntry)
        
        do {
            try viewContext.save()
            print("ExerciseSetEntry saved successfully.")
        } catch {
            print("Error saving context after insert: \(error.localizedDescription)")
        }
    }
    
    // Load the first exerciseSetEntry record from the table
    func load() -> ExerciseSetEntry {
        let fetchRequest = ExerciseSetEntry.fetchRequest()
        
        do {
            let setEntries = try viewContext.fetch(fetchRequest)
            return setEntries.first as? ExerciseSetEntry ?? ExerciseSetEntry()
        } catch {
            print("Error loading exercise set entry: \(error.localizedDescription)")
            return ExerciseSetEntry()
        }
    }
    
    // Remove a specific exerciseSetEntry record from the table
    func remove(exerciseSetEntry: ExerciseSetEntry) {
        viewContext.delete(exerciseSetEntry)
        
        do {
            try viewContext.save()
            print("ExerciseSetEntry successfully removed.")
        } catch {
            print("Error saving context after deletion: \(error.localizedDescription)")
        }
    }
}
