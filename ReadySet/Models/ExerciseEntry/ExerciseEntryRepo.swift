//
//  ExerciseEntryRepo.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/17/24.
//

import Foundation

struct ExerciseEntryRepo: IExerciseEntryRepo {
    let viewContext = PersistenceController.shared.container.viewContext
    
    // Save a new exerciseEntry record to the table
    func save(exerciseEntry: ExerciseEntry) {
        viewContext.insert(exerciseEntry)
        
        do {
            try viewContext.save()
            print("ExerciseSet saved successfully.")
        } catch {
            print("Error saving context after insert: \(error.localizedDescription)")
        }
    }
    
    func loadAll() -> [ExerciseEntry]? {
        let fetchRequest = ExerciseEntry.fetchRequest()
        print("Load all!")

        do {
            let entries = try viewContext.fetch(fetchRequest)
            return entries as? [ExerciseEntry]
        } catch {
            print("Error loading exerciseEntry: \(error.localizedDescription)")
            return nil
        }
    }

    func loadAllFromDay(date: Date) -> [ExerciseEntry]? {
        let fetchRequest = ExerciseEntry.fetchRequest()
        let day = Calendar.current.component(.weekday, from: date)
        print(day)
        fetchRequest.predicate = NSPredicate(format: "day == %ld", day)

        do {
            let sets = try viewContext.fetch(fetchRequest)
            return sets as? [ExerciseEntry]
        } catch {
            print("Error loading exerciseEntry by \(date): \(error.localizedDescription)")
            return nil
        }
    }
    
    func loadByID(uuid: UUID) -> ExerciseEntry? {
        let fetchRequest = ExerciseEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", (\ExerciseEntry.id)._kvcKeyPathString!, uuid.uuidString)

        do {
            let sets = try viewContext.fetch(fetchRequest)
            if sets.count == 1 {
                return sets.first as? ExerciseEntry
            }
        } catch {
            print("Error loading exerciseEntry by \(uuid): \(error.localizedDescription)")
        }
        print("Couldn't find \(uuid.uuidString)")
        return nil

    }

    // Remove a particular exerciseEntry record from the table
    func remove(exerciseEntry: ExerciseEntry) {
        viewContext.delete(exerciseEntry)
        
        do {
            try viewContext.save()
            print("ExerciseEntry successfully removed.")
        } catch {
            print("Error saving context after deletion: \(error.localizedDescription)")
        }
    }
}
