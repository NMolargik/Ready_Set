//
//  ExerciseBottomContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import SwiftUI
import SwiftData

struct ExerciseBottomContentView: View {
    @Query(sort: [SortDescriptor(\Exercise.orderIndex)]) var exercises: [Exercise]
    
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    @State private var sortOrder = SortDescriptor(\Exercise.orderIndex)
    @State private var selectedDay: Int = 1
    
    private let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedDay) {
                ForEach(weekDays.indices, id: \.self) { index in
                    @State var exercises = exercises.filter({$0.weekday == selectedDay})
                
                    ExercisePlanDayView(exercises: $exercises, isEditing: $exerciseViewModel.editingSets, isExpanded: $exerciseViewModel.expandedSets, selectedDay: selectedDay)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            VStack {
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(weekDays.indices, id: \.self) { index in
                        Text(selectedDay == index ? weekDays[index] : String(weekDays[index].prefix(1)))
                            .font(.system(size: selectedDay == index ? 15 : 10))
                            .bold()
                            .foregroundStyle(selectedDay == index ? LinearGradient(colors: [.greenEnd, .green, .greenEnd], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [.secondary], startPoint: .leading, endPoint: .trailing))
                            .padding(.horizontal, 1)
                            .onTapGesture {
                                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
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
                            .transition(.opacity)
                    }
                    
                    editButton
                        .transition(.opacity)
                }
                .drawingGroup()
                .padding(.horizontal, 15)
                .padding(.vertical, 2)
                .onAppear {
                    withAnimation {
                        exerciseViewModel.getCurrentWeekday()
                        selectedDay = exerciseViewModel.currentDay - 1
                    }
                }
                .background {
                    Rectangle()
                        .foregroundStyle(.thickMaterial)
                        .shadow(radius: exerciseViewModel.expandedSets ? 0 : 5, x: 0, y: exerciseViewModel.expandedSets ? 0 : -10)
                }
            }
        }
        .geometryGroup()
    }
    
    private var expandButton: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            withAnimation(.easeInOut) {
                exerciseViewModel.expandedSets.toggle()
            }
        }, label: {
            Text(exerciseViewModel.expandedSets ? "Collapse" : "View All")
                .foregroundStyle(.base)
                .font(.body)
                .tag("edpandButton")
                .padding(.vertical, 2)
                .padding(.horizontal, 5)
                .background {
                    Rectangle()
                        .cornerRadius(10)
                        .foregroundStyle(.baseInvert)
                        .shadow(radius: 3)
                }
        })
        .buttonStyle(.plain)
        .bold()
        .padding(.trailing, 5)
    }

    private var editButton: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            withAnimation(.easeInOut) {
                exerciseViewModel.editingSets.toggle()
            }
        }, label: {
            Image(systemName: exerciseViewModel.editingSets ? "checkmark.circle.fill" : "pencil.circle.fill")
                .foregroundStyle(.baseInvert)
                .font(.system(size: 25))
                .tag("editButton")
        })

        .shadow(radius: 3)
        .buttonStyle(.plain)
        .bold()
        .padding(.trailing, 3)
    }
}

#Preview {
    ExerciseBottomContentView(exerciseViewModel: ExerciseViewModel())
}
