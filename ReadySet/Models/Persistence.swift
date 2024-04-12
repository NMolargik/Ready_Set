//
//  Persistence.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/10/24.
//

import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    var container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "ReadySet")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error initializing Core Data: \(error.localizedDescription)")
            }
        }
    }

    func getUser() -> NSEntityDescription {
        NSEntityDescription.entity(forEntityName: "User", in: container.viewContext) ?? NSEntityDescription()
    }
    
    func getExerciseSet() -> NSEntityDescription {
        NSEntityDescription.entity(forEntityName: "ExerciseSet", in: container.viewContext) ?? NSEntityDescription()
    }
    
    func getExerciseSetEntry() -> NSEntityDescription {
        NSEntityDescription.entity(forEntityName: "ExerciseSetEntry", in: container.viewContext) ?? NSEntityDescription()
    }
}
