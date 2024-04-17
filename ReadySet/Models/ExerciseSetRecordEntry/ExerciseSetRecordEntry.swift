//
//  ExerciseSetRecordEntry.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/10/24.
//

import Foundation
import CoreData

@objc(ExerciseSetRecordEntry)
public class ExerciseSetRecordEntry: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var setID: String
    @NSManaged public var timestamp: Date
    @NSManaged public var amountRecorded: Int16
    
    convenience init(
        id: UUID,
        setID: String,
        timestamp: Date,
        amountRecorded: Int16
    ) {
        let entity = PersistenceController.shared.getExerciseSetEntry()
        self.init(entity: entity, insertInto: nil)
        
        self.id = id
        self.setID = setID
        self.timestamp = timestamp
        self.amountRecorded = amountRecorded
    }
}
