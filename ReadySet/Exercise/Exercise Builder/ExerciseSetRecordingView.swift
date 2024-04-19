//
//  ExerciseSetRecordingView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/19/24.
//

import SwiftUI

struct ExerciseSetRecordingView: View {
    @Binding var selectedSet: ExerciseSet

    var body: some View {
        HStack {
            VStack(spacing: 0) {
                if selectedSet.goalType == .duration {
                    CustomStepperView(value: $selectedSet.durationToDo, step: 5, iconName: "stopwatch.fill", colors: [.purpleStart, .purpleEnd])
                    
                } else {
                    CustomStepperView(value: $selectedSet.weightToLift, step: 5, iconName: "scalemass.fill", colors: [.blueStart, .blueEnd])
                    
                    CustomStepperView(value: $selectedSet.repetitionsToDo, step: 1, iconName: "repeat", colors: [.orangeStart, .orangeEnd])
                }
            }
            
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                withAnimation {
                    selectedSet = ExerciseSet()
                }
            }, label: {
                Text("Save")
                    .foregroundStyle(LinearGradient(colors: [.greenStart, .greenEnd], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .bold()
            })
            .buttonStyle(.plain)
            .padding(.horizontal, 5)
        }
        .padding(.vertical, 3)
        .padding(.horizontal, 5)
        .background(ZStack {
            Rectangle()
                .foregroundStyle(.thickMaterial)
                .shadow(radius: 5)
            Rectangle()
                .blendMode(.destinationOut)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.baseInvert, lineWidth: 1)
                )
        }
        .compositingGroup())
        .animation(.easeInOut, value: selectedSet)
        .padding(.leading)
    }
}
