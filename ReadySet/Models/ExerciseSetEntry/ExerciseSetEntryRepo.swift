//
//  ExerciseSetEntryRepo.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/12/24.
//

import Foundation

struct ExerciseSetEntryRepo: IExerciseSetEntryRepo {
    let viewContext = PersistenceController.shared.container.viewContext
    
    // Save a new exerciseSetEntry record to the table
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
    func loadAll() -> [ExerciseSetEntry]? {
        let fetchRequest = ExerciseSetEntry.fetchRequest()
        print("Load all!")

        do {
            let sets = try viewContext.fetch(fetchRequest)
            return sets as? [ExerciseSetEntry]
        } catch {
            print("Error loading exerciseSetEntry: \(error.localizedDescription)")
            return nil
        }
    }

    func loadAllFromDay(date: Date) -> [ExerciseSetEntry]? {
        let fetchRequest = ExerciseSetEntry.fetchRequest()
        let day = Calendar.current.component(.weekday, from: date)
        print(day)
        fetchRequest.predicate = NSPredicate(format: "day == %ld", day)

        do {
            let sets = try viewContext.fetch(fetchRequest)
            return sets as? [ExerciseSetEntry]
        } catch {
            print("Error loading exerciseSetEntry by \(date): \(error.localizedDescription)")
            return nil
        }
    }
    
    func loadByID(uuid: UUID) -> ExerciseSetEntry? {
        let fetchRequest = ExerciseSetEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", (\ExerciseSetEntry.id)._kvcKeyPathString!, uuid.uuidString)

        do {
            let sets = try viewContext.fetch(fetchRequest)
            if sets.count == 1 {
                return sets.first as? ExerciseSetEntry
            }
        } catch {
            print("Error loading exerciseSetEntry by \(uuid): \(error.localizedDescription)")
        }
        print("Couldn't find \(uuid.uuidString)")
        return nil

    }

    // Remove a particular exerciseSetEntry record from the table
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
