//
//  ExerciseBottomContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/14/24.
//

import SwiftUI
import SwiftData

struct ExerciseBottomContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Exercise.orderIndex)]) var exercises: [Exercise]
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    @State private var sortOrder = SortDescriptor(\Exercise.orderIndex)
    @Binding var selectedDay: Int
    
    private let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 6) {
                    ForEach(weekDays.indices, id: \.self) { index in
                        Text(selectedDay == index ? weekDays[index] : String(weekDays[index].prefix(1)))
                            .font(.system(size: selectedDay == index ? 15 : 10))
                            .bold()
                            .foregroundStyle(selectedDay == index ? LinearGradient(colors: [.greenEnd, .green, .greenEnd], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [.secondary], startPoint: .leading, endPoint: .trailing))
                            .padding(.horizontal, 4)
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
                .padding(.horizontal, 10)
                .padding(.top, 5)
                
                TabView(selection: $selectedDay) {
                    ForEach(weekDays.indices, id: \.self) { index in
                        ExercisePlanDayView(exercises: exercises.filter({ $0.weekday == selectedDay }), isEditing: $exerciseViewModel.editingSets, isExpanded: $exerciseViewModel.expandedSets, selectedDay: selectedDay)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onAppear {
                    UIScrollView.appearance().isScrollEnabled = false
                }
            }
            
            .padding(.horizontal)
        }
        .animation(.easeIn, value: exerciseViewModel.expandedSets)
    }
    
    private var expandButton: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            withAnimation {
                exerciseViewModel.expandedSets.toggle()
            }
        }, label: {
            Image(systemName: exerciseViewModel.expandedSets ? "arrow.up.right.and.arrow.down.left.circle.fill" : "arrow.up.left.and.arrow.down.right.circle.fill")
                .foregroundStyle(.baseInvert)
                .font(.system(size: 25))
                .tag("edpandButton")
        })
        .shadow(radius: 3)
        .buttonStyle(.plain)
        .bold()
    }

    private var editButton: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            withAnimation {
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
    }
}
//
//#Preview {
//    ExerciseBottomContentView(selectedDay: 1, exerciseViewModel: ExerciseViewModel())
//}
