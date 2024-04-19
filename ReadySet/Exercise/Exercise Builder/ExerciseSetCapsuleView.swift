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
                withAnimation {
                    selectedSet = set
                }
            }, label: {
                HStack {
                    if (set.goalType == .duration) {
                        Image(systemName: "stopwatch.fill")
                            .foregroundStyle(LinearGradient(colors: [.purpleStart, .purpleEnd], startPoint: .leading, endPoint: .trailing))
                        
                        Text(set.durationToDo.description)
                            .foregroundStyle(.base)
                    } else {
                        Image(systemName: "scalemass.fill")
                            .foregroundStyle(LinearGradient(colors: [.blueStart, .blueEnd], startPoint: .leading, endPoint: .trailing))
                        
                        Text(set.weightToLift.description)
                            .foregroundStyle(.base)
                        
                        Image(systemName: "repeat")
                            .foregroundStyle(LinearGradient(colors: [.orangeStart, .orangeEnd], startPoint: .leading, endPoint: .trailing))
                        
                        Text(set.repetitionsToDo.description)
                            .foregroundStyle(.base)
                    }
                }
                .lineLimit(1)
                .padding(3)
                .background {
                    Rectangle()
                        .foregroundStyle(.baseInvert)
                        .cornerRadius(5)
                    
                }
            })
            .buttonStyle(.plain)
        }
        .transition(.move(edge: .leading).combined(with: .opacity))
    }
}
