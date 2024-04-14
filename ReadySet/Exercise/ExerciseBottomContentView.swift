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
        ZStack {
            Rectangle()
                .cornerRadius(35)
                .foregroundStyle(.ultraThinMaterial)
                .shadow(radius: 1)
            
            ExercisePlanView(isEditing: $isEditingPlan)
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 15)
    }
}

#Preview {
    ExerciseBottomContentView()
}
