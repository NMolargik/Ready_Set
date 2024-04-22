//
//  ExerciseSetRecordingView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/19/24.
//

import SwiftUI

struct ExerciseSetRecordingView: View {
    @State var set: ExerciseSet
    @Binding var selectedSet: String

    var body: some View {
        HStack {
            VStack(spacing: 0) {
                if set.goalType == .duration {
                    CustomStepperView(value: $set.durationToDo, step: 5, iconName: "stopwatch.fill", colors: [.purpleStart, .purpleEnd])
                    
                } else {
                    CustomStepperView(value: $set.weightToLift, step: 5, iconName: "dumbbell.fill", colors: [.greenStart, .greenEnd])
                    
                    CustomStepperView(value: $set.repetitionsToDo, step: 1, iconName: "repeat", colors: [.orangeStart, .orangeEnd])
                }
            }
            
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedSet = ""
                }
            }, label: {
                Text("Save")
                    .foregroundStyle(.greenEnd)
                    .bold()
            })
            .buttonStyle(.plain)
            .padding(.horizontal, 5)
        }
        .padding(.vertical, 3)
        .padding(.horizontal, 5)
        .background(
            Rectangle()
                .foregroundStyle(.baseAccent)
                .shadow(radius: 5)
                .cornerRadius(5)
        )
        .compositingGroup()
        .animation(.easeInOut, value: selectedSet)
        .padding(.leading)
    }
}
