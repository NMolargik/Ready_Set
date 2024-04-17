//
//  ExerciseStatWidgetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI
import Foundation

struct ExerciseStatWidgetView: View {
    @Binding var totalSets: Int
    @Binding var weeklySteps: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(10)
                .foregroundStyle(.thinMaterial)
                .shadow(radius: 1)
        
            VStack (alignment: .leading) {
                Text("Sets Recorded: \(totalSets)")
                
                Text("Weekly Steps: \(weeklySteps)")
                    
            }
            .font(.caption)
            .foregroundStyle(.fontGray)
        }
        .frame(height: 35)
    }
}

#Preview {
    ExerciseStatWidgetView(totalSets: .constant(10), weeklySteps: .constant(5000))
}
