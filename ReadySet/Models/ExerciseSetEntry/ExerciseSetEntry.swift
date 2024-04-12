//
//  ExerciseEntrySet.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/10/24.
//

import Foundation
import CoreData

@objc(ExerciseSetEntry)
public class ExerciseSetEntry: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var setID: String
    @NSManaged public var timestamp: Date
    @NSManaged public var repetitions: Int
    @NSManaged public var duration: Int
    @NSManaged public var weightLifted: Int
    
    convenience init(
        id: UUID,
        setID: String,
        timestamp: Date,
        repetitions: Int?,
        duration: Int?,
        weightLifted: Int?
    ) {
        let entity = PersistenceController.shared.getExerciseSetEntry()
        self.init(entity: entity, insertInto: nil)
        
        self.id = id
        self.setID = setID
        self.timestamp = timestamp
        self.repetitions = repetitions ?? 0
        self.duration = duration ?? 0
        self.weightLifted = weightLifted ?? 0
    }
}
