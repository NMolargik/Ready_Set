//
//  ExerciseBottomContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import SwiftUI

struct ExerciseBottomContentView: View {
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    @State private var selectedDay: Int = 1
    
    private let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        VStack {
            HStack(spacing: 6) {
                ForEach(weekDays.indices, id: \.self) { index in
                    Text(selectedDay == index ? weekDays[index] : String(weekDays[index].prefix(1)))
                        .font(.system(size: selectedDay == index ? 18 : 10))
                        .bold()
                        .foregroundStyle(selectedDay == index ? LinearGradient(colors: [.greenEnd, .green, .greenEnd], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [.secondary], startPoint: .leading, endPoint: .trailing))
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                selectedDay = index
                            }
                        }
                        .animation(.bouncy, value: selectedDay)
                        .zIndex(selectedDay == index ? 2 : 1)
                        .transition(.opacity)
                }
                Spacer()
                
                if (!exerciseViewModel.editingSets) {
                    expandButton
                        .animation(.easeInOut, value: selectedDay)
                }
                
                Spacer()
                
                editButton
            }
            .padding(.horizontal, 10)
            .padding(.top, 5)
            
            TabView(selection: $selectedDay) {
                ForEach(weekDays.indices, id: \.self) { index in
                    ExercisePlanDayView(exerciseViewModel: exerciseViewModel, selectedDay: $selectedDay)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .padding(5)
        .onAppear {
            withAnimation {
                exerciseViewModel.getCurrentWeekday()
                selectedDay = exerciseViewModel.currentDay - 1
            }
        }
    }
    
    
    private var expandButton: some View {
        Button(action: {
            withAnimation {
                exerciseViewModel.expandedSets.toggle()
            }
        }, label: {
            Image(systemName: exerciseViewModel.expandedSets ? "chevron.down" : "chevron.up")
                .foregroundStyle(.greenEnd)
        })
    }

    private var editButton: some View {
        Button(exerciseViewModel.editingSets ? "Save" : "Edit") {
            withAnimation {
                exerciseViewModel.editingSets.toggle()
                //TODO: save stuff
            }
        }
        .buttonStyle(.plain)
        .bold()
        .foregroundStyle(.greenEnd)
    }
}

// Preview
#Preview {
    ExerciseBottomContentView(exerciseViewModel: ExerciseViewModel())
}
