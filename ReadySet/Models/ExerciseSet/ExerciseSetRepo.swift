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
    func loadAll() -> [ExerciseSet]? {
        let fetchRequest = ExerciseSet.fetchRequest()
        print("Load all!")

        do {
            let sets = try viewContext.fetch(fetchRequest)
            return sets as? [ExerciseSet]
        } catch {
            print("Error loading exerciseSet: \(error.localizedDescription)")
            return nil
        }
    }

    func loadAllFromDay(date: Date) -> [ExerciseSet]? {
        let fetchRequest = ExerciseSet.fetchRequest()
        let day = Calendar.current.component(.weekday, from: date)
        print(day)
        fetchRequest.predicate = NSPredicate(format: "day == %ld", day)

        do {
            let sets = try viewContext.fetch(fetchRequest)
            return sets as? [ExerciseSet]
        } catch {
            print("Error loading exerciseSet by \(date): \(error.localizedDescription)")
            return nil
        }
    }
    
    func loadByID(uuid: UUID) -> ExerciseSet? {
        let fetchRequest = ExerciseSet.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", (\ExerciseSet.id)._kvcKeyPathString!, uuid.uuidString)

        do {
            let sets = try viewContext.fetch(fetchRequest)
            if sets.count == 1 {
                return sets.first as? ExerciseSet
            }
        } catch {
            print("Error loading exerciseSet by \(uuid): \(error.localizedDescription)")
        }
        print("Couldn't find \(uuid.uuidString)")
        return nil

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
