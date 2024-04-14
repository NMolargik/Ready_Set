//
//  ExercisePlanDayView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import SwiftUI
import Foundation

struct ExercisePlanDayView: View {
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    @State var isEditing: Bool
    
    @State var selectedDay: Int = 0
    
    let exerciseSetRepo = ExerciseSetRepo()
    
    var body: some View {
        VStack {
            ForEach(exerciseViewModel.exerciseSetsMaster.filter({ $0.day == selectedDay })) { set in
                Text(set.order.description)
                
            }
        }
        .onAppear {
            exerciseSetRepo.save(exerciseSet: ExerciseSet(id: UUID(), exerciseName: "Sit Up", activityType: "Duration", day: 1, order: Int.random(in: 0...16)))
        }
    }
}

#Preview {
    ExercisePlanDayView(exerciseViewModel: ExerciseViewModel(), isEditing: false)
}
