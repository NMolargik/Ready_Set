//
//  Exercise.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/17/24.
//

import Foundation
import SwiftData

@Model
class Exercise: Identifiable {
    var id: UUID
    var weekday: Int
    var orderIndex: Int
    var name: String
    @Relationship(deleteRule: .cascade) var exerciseSets = [ExerciseSet]()
    
    init(id: UUID = UUID(), weekday: Int = 0, orderIndex: Int = 0, name: String = "Unnamed Exercise") {
        self.id = id
        self.weekday = weekday
        self.orderIndex = orderIndex
        self.name = name
    }
}
