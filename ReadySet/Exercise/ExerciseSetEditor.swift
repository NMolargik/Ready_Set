//
//  SwiftUIView.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/18/24.
//

import SwiftUI

struct ExerciseSetEditor: View {
    @Bindable var set: ExerciseSet
    var goalType: GoalType
    
    init(set: ExerciseSet) {
        self.set = set
        self.goalType = set.goalType
    }

    var body: some View {
        HStack {
            VStack {
                Picker("Type", selection: $set.goalType) {
                    Text("Duration").tag(GoalType.duration)
                    Text("Reps").tag(GoalType.weight)
                }
                .frame(width: 150)
                .pickerStyle(.segmented)
                
                Spacer()
            }
            
            VStack {
                if ($set.wrappedValue.goalType == .duration) {
                    
                    Stepper(value: self.$set.durationToDo, label: {
                        HStack {
                            Image(systemName: "stopwatch")
                                .foregroundStyle(.greenEnd)
                            
                            Text(self.set.durationToDo.description)
                                .bold()
                                .foregroundStyle(.baseInvert)
                        }
                    })
                    
                } else {
                    Stepper(value: self.$set.weightToLift, label: {
                        HStack {
                            Image(systemName: "scalemass")
                                .foregroundStyle(.baseInvert)
                            
                            Text(set.weightToLift.description)
                                .bold()
                                .foregroundStyle(.baseInvert)
                        }
                    })
                    
                    Stepper(value: self.$set.repetitionsToDo, label: {
                        HStack {
                            Image(systemName: "repeat")
                                .foregroundStyle(.orangeEnd)
                            
                            Text(set.repetitionsToDo.description)
                                .bold()
                                .foregroundStyle(.baseInvert)
                        }
                    })
                }
            }
        }
        .padding(3)
        .background {
            ZStack {
                Rectangle()
                    .foregroundStyle(.thickMaterial)
                    .shadow(radius: 5)
                Rectangle()
                    .blendMode(.destinationOut)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.baseInvert, lineWidth: 1)
                    )
            }
            .compositingGroup()
        }
    }
}

#Preview {
    ExerciseSetEditor(set: ExerciseSet())
}
