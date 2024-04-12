//
//  ExerciseSetRepo.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/12/24.
//

import Foundation

struct ExerciseSetRepo: IExerciseSetRepo {
    let viewContext = PersistenceController.shared.container.viewContext
    
    func save(exerciseSet: ExerciseSet) {
        viewContext.insert(exerciseSet)
        
        do {
            try viewContext.save()
            print("ExerciseSet saved successfully.")
        } catch {
            print("Error saving context after insert: \(error.localizedDescription)")
        }
    }
    
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
