//
//  ExerciseSetCapsuleView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/19/24.
//

import SwiftUI

struct ExerciseSetCapsuleView: View {
    @State var set: ExerciseSet
    @Binding var selectedSet: String
    
    var body: some View {
        HStack (alignment: .center) {
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                selectedSet = set.id.uuidString
                print(set.timestamp.description)
            }, label: {
                HStack {
                    if (set.goalType == .duration) {
                        Image(systemName: "stopwatch.fill")
                            .foregroundStyle(LinearGradient(colors: [.purpleStart, .purpleEnd], startPoint: .leading, endPoint: .trailing))
                        
                        Text(set.durationToDo.formatted())
                            .foregroundStyle(.baseInvert)
                    } else {
                        Image(systemName: "dumbbell.fill")
                            .foregroundStyle(LinearGradient(colors: [.greenStart, .greenEnd], startPoint: .leading, endPoint: .trailing))
                        
                        Text(set.weightToLift.formatted())
                            .foregroundStyle(.baseInvert)
                        
                        Image(systemName: "repeat")
                            .foregroundStyle(LinearGradient(colors: [.orangeStart, .orangeEnd], startPoint: .leading, endPoint: .trailing))
                        
                        Text(set.repetitionsToDo.formatted())
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
        .drawingGroup()
    }
}
