//
//  ExerciseEntry.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/17/24.
//

import Foundation
import CoreData

@objc(ExerciseEntry)
public class ExerciseEntry: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var day: Int16
    @NSManaged public var exerciseOrder: Int16
    @NSManaged public var exerciseName: String
    
    convenience init(
        id: UUID,
        day: Int16,
        exerciseOrder: Int16,
        exerciseName: String
    ) {
        let entityName = "ExerciseEntry" // Set the entity name here
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: PersistenceController.shared.container.viewContext) else {
            fatalError("Failed to initialize ExerciseEntry entity")
        }
        
        self.init(entity: entity, insertInto: PersistenceController.shared.container.viewContext)
        
        self.id = id
        self.day = day
        self.exerciseOrder = exerciseOrder
        self.exerciseName = exerciseName
    }
}
