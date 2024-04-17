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
    @Binding var actualDay: Int
    @State var selectedDay: Int = 1
    
    let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        VStack {
            TabView(selection: $selectedDay) {
                ForEach(0..<weekDays.count, id: \.self) { index in
                    ExercisePlanDayView(exerciseViewModel: exerciseViewModel, isEditing: isEditing, selectedDay: $selectedDay)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            HStack(spacing: 0) {
                ForEach(weekDays.indices, id: \.self) { index in
                    Text(String(weekDays[index].prefix(1)))
                        .font(.system(size: selectedDay == index ? 18 : 10))
                        .bold()
                        .frame(width: 25)
                        //.background(selectedDay == index ? Color.blue : Color.clear)
                        .foregroundColor(selectedDay == index ? .primary : .secondary)
                        .clipShape(Circle())
                        .onTapGesture {
                            withAnimation {
                                selectedDay = index
                            }
                        }
                        .animation(.easeInOut, value: selectedDay)
                }
            }
            .padding(.horizontal)
            .clipShape(Capsule())
            .padding(.horizontal, 10)
        }
        .padding(5)
    }
}

// Preview your view
struct ExercisePlanView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisePlanView(exerciseViewModel: ExerciseViewModel(), isEditing: .constant(false), actualDay: .constant(2))
    }
}
