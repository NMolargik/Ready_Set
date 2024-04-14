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
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            HStack {
                Button(action: {
                    withAnimation {
                        selectedDay == 0 ? selectedDay = 6 : (selectedDay -= 1)
                    }
                }, label: {
                    Image(systemName: "arrow.left")
                })
                
                Text(weekDays[selectedDay])
                    .bold()
                    .frame(width: 200)
                
                Button(action: {
                    withAnimation {
                        selectedDay == 6 ? selectedDay = 0 : (selectedDay += 1)
                    }
                }, label: {
                    Image(systemName: "arrow.right")
                })
            }
            .shadow(radius: 1, x: 0, y: 2)
            .font(.title)
            .foregroundStyle(.primary)
            
        }
        .padding(5)
    }
}

#Preview {
    ExerciseBottomContentView()
}
