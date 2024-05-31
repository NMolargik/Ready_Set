//
//  ExerciseSetRecordView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/22/24.
//

import SwiftUI

struct ExerciseSetRecordView: View {
    @Binding var exercise: Exercise
    @Binding var selectedSet: String

    var body: some View {
        HStack {
            FlowLayout(alignment: .leading, spacing: 10) {
                ForEach($exercise.exerciseSets.sorted(by: { $0.wrappedValue.timestamp < $1.wrappedValue.timestamp }), id: \.id) { $set in
                    ExerciseSetView(set: $set, selectedSet: $selectedSet)
                }
            }
            Spacer(minLength: 1)
        }
        .padding(.horizontal)
        .geometryGroup()
    }
}
