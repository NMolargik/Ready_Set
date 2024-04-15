//
//  ExercisePlanView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import SwiftUI

struct ExercisePlanView: View {
    @ObservedObject var exerciseViewModel = ExerciseViewModel()
    @Binding var isEditing: Bool
    
    @State var selectedDay: Int = 1
    
    let weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        VStack {
            TabView(selection: $selectedDay) {
                ForEach(0..<weekDays.count, id: \.self) { index in
                    ExercisePlanDayView(exerciseViewModel: exerciseViewModel, isEditing: isEditing, selectedDay: selectedDay)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
        .padding(5)
    }
}

#Preview {
    ExerciseBottomContentView()
}
