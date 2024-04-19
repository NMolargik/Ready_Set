//
//  ExerciseWeeklyStepsWidgetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI
import Foundation

struct ExerciseWeeklyStepsWidgetView: View {
    @Binding var weeklySteps: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(10)
                .foregroundStyle(.thinMaterial)
                .shadow(radius: 1)
        
            HStack (spacing: 1) {
                Image(systemName: "calendar")
                    .foregroundStyle(.baseInvert)
                    .font(.body)
                
                Text("Weekly Steps: \(weeklySteps)")
                    
            }
            .font(.caption)
            .foregroundStyle(.fontGray)
        }
        .frame(height: 35)
    }
}

#Preview {
    ExerciseWeeklyStepsWidgetView(weeklySteps: .constant(5000))
}