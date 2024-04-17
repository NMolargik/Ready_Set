//
//  ExerciseSetEntry.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/10/24.
//

import Foundation
import CoreData

@objc(ExerciseSetEntry)
public class ExerciseSetEntry: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var exerciseID: String
    @NSManaged public var activityType: String
    @NSManaged public var setOrder: Int16

    convenience init(
        id: UUID,
        exerciseID: String,
        activityType: String,
        setOrder: Int16
    ) {
        let entity = PersistenceController.shared.getExerciseSetEntry()
        self.init(entity: entity, insertInto: nil)
        
        self.id = id
        self.exerciseID = exerciseID
        self.activityType = activityType
        self.setOrder = setOrder
    }
}
