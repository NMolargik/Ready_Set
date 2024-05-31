//
//  ExerciseSetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 5/31/24.
//

import SwiftUI

struct ExerciseSetView: View {
    @Binding var set: ExerciseSet
    @Binding var selectedSet: String

    var body: some View {
        VStack {
            if set.id.uuidString == selectedSet {
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
                            .foregroundStyle(.blue)
                            .bold()
                    })
                    .buttonStyle(.plain)
                    .padding(.horizontal, 5)
                }
                .padding(.vertical, 3)
                .padding(.horizontal, 5)
                .padding(.leading)
                .compositingGroup()
            } else {
                HStack(alignment: .center) {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedSet = set.id.uuidString
                        }
                    }, label: {
                        HStack {
                            if set.goalType == .duration {
                                Image(systemName: "stopwatch.fill")
                                    .foregroundStyle(LinearGradient(colors: [.purpleStart, .purpleEnd], startPoint: .leading, endPoint: .trailing))
                                Text(set.durationToDo.formatted())
                                    .foregroundStyle(.base)
                            } else {
                                Image(systemName: "dumbbell.fill")
                                    .foregroundStyle(LinearGradient(colors: [.greenStart, .greenEnd], startPoint: .leading, endPoint: .trailing))
                                Text(set.weightToLift.formatted())
                                    .foregroundStyle(.base)
                                Image(systemName: "repeat")
                                    .foregroundStyle(LinearGradient(colors: [.orangeStart, .orangeEnd], startPoint: .leading, endPoint: .trailing))
                                Text(set.repetitionsToDo.formatted())
                                    .foregroundStyle(.base)
                            }
                        }
                        .lineLimit(1)
                        .padding(3)
                    })
                    .buttonStyle(.plain)
                }
                .drawingGroup()
                .id(set.id)
            }
        }
        .background {
            Rectangle()
                .cornerRadius(5)
                .foregroundStyle(.baseInvert)
                .shadow(radius: 5, x: 5, y: 5)
        }
    }
}

#Preview {
    ExerciseSetRecordView(exercise: .constant(Exercise()), selectedSet: .constant(""))
}
