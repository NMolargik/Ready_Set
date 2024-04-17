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
    @Binding var selectedDay: Int
    
    @State var exercises: [ExerciseEntry] = []
    @State var sets: [ExerciseSetEntry] = []
    
    let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        Text("Woops")
    }
}
