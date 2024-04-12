//
//  ExerciseSetEntryRepo.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/12/24.
//

import Foundation

struct ExerciseSetEntryRepo: IExerciseSetEntryRepo {
    let viewContext = PersistenceController.shared.container.viewContext
    
    func save(exerciseSetEntry: ExerciseSetEntry) {
        viewContext.insert(exerciseSetEntry)
        
        do {
            try viewContext.save()
            print("ExerciseSetEntry saved successfully.")
        } catch {
            print("Error saving context after insert: \(error.localizedDescription)")
        }
    }
    
    func load() -> ExerciseSetEntry {
        let fetchRequest = ExerciseSetEntry.fetchRequest()
        
        do {
            let user = try viewContext.fetch(fetchRequest)
            return user.first as? ExerciseSetEntry ?? ExerciseSetEntry()
        } catch {
            print("Error loading exercise set entry: \(error.localizedDescription)")
            return ExerciseSetEntry()
        }
    }
    
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
