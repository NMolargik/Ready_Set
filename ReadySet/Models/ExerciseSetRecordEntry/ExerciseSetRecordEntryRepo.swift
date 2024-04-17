//
//  ExerciseSetRecordEntryRepo.swift
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
import CoreData

struct ExerciseSetRecordEntryRepo: IExerciseSetRecordEntryRepo {
    let viewContext = PersistenceController.shared.container.viewContext
    
    // Insert a new exerciseSetRecordEntry record
    func save(exerciseSetRecordEntry: ExerciseSetRecordEntry) {
        viewContext.insert(exerciseSetRecordEntry)
        
        do {
            try viewContext.save()
            print("ExerciseSetRecordEntry saved successfully.")
        } catch {
            print("Error saving context after insert: \(error.localizedDescription)")
        }
    }
    
    // Load the first exerciseSetRecordEntry record from the table
    func load() -> ExerciseSetRecordEntry {
        let fetchRequest = ExerciseSetRecordEntry.fetchRequest()
        
        do {
            let setRecordEntries = try viewContext.fetch(fetchRequest)
            return setRecordEntries.first as? ExerciseSetRecordEntry ?? ExerciseSetRecordEntry()
        } catch {
            print("Error loading exercise set record entry: \(error.localizedDescription)")
            return ExerciseSetRecordEntry()
        }
    }
    
    func loadAll() -> [ExerciseSetRecordEntry]? {
        let fetchRequest = ExerciseSetRecordEntry.fetchRequest()
        print("Load all!")

        do {
            let records = try viewContext.fetch(fetchRequest)
            return records as? [ExerciseSetRecordEntry]
        } catch {
            print("Error loading all exerciseSetRecordEntry: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Remove a specific exerciseSetRecordEntry record from the table
    func remove(exerciseSetRecordEntry: ExerciseSetRecordEntry) {
        viewContext.delete(exerciseSetRecordEntry)
        
        do {
            try viewContext.save()
            print("ExerciseSetRecordEntry successfully removed.")
        } catch {
            print("Error saving context after deletion: \(error.localizedDescription)")
        }
    }
    
    func removeAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ExerciseSetRecordEntry.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeCount
        
        do {
            if let result = try viewContext.execute(deleteRequest) as? NSBatchDeleteResult,
               let count = result.result as? Int {
                print("\(count) ExerciseSetRecordEntry records deleted successfully.")
            }
            try viewContext.save()
        } catch {
            print("Error deleting all ExerciseSetRecordEntry records: \(error.localizedDescription)")
        }
    }
    
    // Return the count of records in the table
    func count() -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExerciseSetRecordEntry")
        
        do {
            let count = try viewContext.count(for: fetchRequest)
            if count == NSNotFound {
                print("Could not fetch count")
                return 0
            } else {
                return count
            }
        } catch {
            print("Error fetching count of exercise set record entries: \(error.localizedDescription)")
            return 0
        }
    }
}
