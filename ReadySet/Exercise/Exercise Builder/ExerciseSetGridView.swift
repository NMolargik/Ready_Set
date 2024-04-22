//
//  ExerciseSetGridView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/19/24.
//

import SwiftUI

struct ExerciseSetGridView: View {
    @State var exercise: Exercise
    @Binding var isEditing: Bool
    
    @State private var selectedSet: ExerciseSet = ExerciseSet()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(exercise.exerciseSets, id: \.self) { set in
                    if (selectedSet.id == set.id) {
                        ExerciseSetRecordingView(selectedSet: $selectedSet)
                        
                    } else {
                        ExerciseSetCapsuleView(set: set, selectedSet: $selectedSet)
                    }
                }
            }
        }
    }
}
