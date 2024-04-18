//
//  SwiftUIView.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/18/24.
//

import SwiftUI

struct ExerciseSetEditor: View {
    @Bindable var set: ExerciseSet
    
    

    var body: some View {
        VStack {
            Stepper("Duration", value: self.$set.durationToDo)
            Stepper("Repititions", value: self.$set.repetitionsToDo)
        }
    }
}

