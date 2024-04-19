//
//  ExerciseWeeklyStepsWidgetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct ExerciseWeeklyStepsWidgetView: View {
    @Binding var weeklySteps: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(10)
                .foregroundStyle(.thinMaterial)
                .shadow(radius: 1)
        
            Text("Weekly Steps: \(weeklySteps)")
                .font(.caption)
                .foregroundStyle(.fontGray)
        }
        .frame(height: 35)
    }
}

#Preview {
    ExerciseWeeklyStepsWidgetView(weeklySteps: .constant(5000))
}
