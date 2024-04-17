//
//  ExerciseBottomContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct ExerciseBottomContentView: View {
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    
    @State var isEditingPlan = false
    
    var body: some View {
        //TODO: add a few more things
        ExercisePlanView(exerciseViewModel: exerciseViewModel, actualDay: $exerciseViewModel.currentDay)
    }
}

#Preview {
    ExerciseBottomContentView(exerciseViewModel: ExerciseViewModel())
}
