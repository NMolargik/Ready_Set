//
//  ExerciseBottomContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct ExerciseBottomContentView: View {
    @State var isEditingPlan = false
    
    var body: some View {
        //TODO: add a few more things
        ExercisePlanView(isEditing: $isEditingPlan)
    }
}

#Preview {
    ExerciseBottomContentView()
}
