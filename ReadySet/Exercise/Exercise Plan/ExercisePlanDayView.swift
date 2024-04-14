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
            ForEach(exerciseViewModel.exerciseSetMaster.filter({ $0.day == selectedDay })) { set in
                Text(set.order.description)
                
            }
        }
    }
}

#Preview {
    ExercisePlanDayView(exerciseViewModel: ExerciseViewModel(), isEditing: false)
}
