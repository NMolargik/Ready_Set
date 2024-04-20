//
//  ExerciseSetCapsuleView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/19/24.
//

import SwiftUI

struct ExerciseSetCapsuleView: View {
    @State var set: ExerciseSet
    @Binding var selectedSet: ExerciseSet
    
    var body: some View {
        HStack (alignment: .center) {
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedSet = set
                }
            }, label: {
                HStack {
                    if (set.goalType == .duration) {
                        Image(systemName: "stopwatch.fill")
                            .foregroundStyle(LinearGradient(colors: [.purpleStart, .purpleEnd], startPoint: .leading, endPoint: .trailing))
                        
                        Text(set.durationToDo.description)
                            .foregroundStyle(.baseInvert)
                    } else {
                        Image(systemName: "dumbbell.fill")
                            .foregroundStyle(LinearGradient(colors: [.greenStart, .greenEnd], startPoint: .leading, endPoint: .trailing))
                        
                        Text(set.weightToLift.description)
                            .foregroundStyle(.baseInvert)
                        
                        Image(systemName: "repeat")
                            .foregroundStyle(LinearGradient(colors: [.orangeStart, .orangeEnd], startPoint: .leading, endPoint: .trailing))
                        
                        Text(set.repetitionsToDo.description)
                            .foregroundStyle(.baseInvert)
                    }
                }
                .lineLimit(1)
                .padding(3)
                .background {
                    Rectangle()
                        .foregroundStyle(.baseAccent)
                        .cornerRadius(5)
                }
                .shadow(radius: 5, x: 3, y: 3)
            })
            .buttonStyle(.plain)
        }
        .transition(.move(edge: .leading).combined(with: .opacity))
    }
}
