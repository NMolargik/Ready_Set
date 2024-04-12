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
    @NSManaged public var day: Int
    @NSManaged public var order: Int
    
    convenience init(
        id: UUID,
        exerciseName: String,
        activityType: String,
        day: Int,
        order: Int
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
