//
//  Set.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/10/24.
//

import Foundation
import CoreData

@objc(ExerciseSet)
public class ExerciseSet: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var exerciseName: String
    @NSManaged public var activityType: String
    @NSManaged public var day: Int16
    @NSManaged public var order: Int16
    
    convenience init(
        id: UUID,
        exerciseName: String,
        activityType: String,
        day: Int16,
        order: Int16
    ) {
        let entity = PersistenceController.shared.getExerciseSet()
        self.init(entity: entity, insertInto: nil)
        
        self.id = id
        self.exerciseName = exerciseName
        self.activityType = activityType
        self.day = day
        self.order = order
    }
}
