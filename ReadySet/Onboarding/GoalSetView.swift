//
//  GoalSetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI
import SwiftData

struct GoalSetView: View {
    @AppStorage("appState") var appState: String = "goalSetting"
    @Binding var onboardingProgress: Float
    @Binding var onboardingGradient: LinearGradient
    @Query(sort: [SortDescriptor(\Exercise.orderIndex)]) var exercises: [Exercise]
    @State private var showText = false
    @State private var showMoreText = false
    @State private var selectedDay = 1
    
    let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        ZStack {
            Color.base
            VStack {
                if showText {
                    Spacer()
                    
                    Text("Tap days to enter Sets, or skip until later")
                        .multilineTextAlignment(.center)
                        .font(.body)
                        .foregroundStyle(.fontGray)
                        .padding(.horizontal)
                        .transition(.push(from: .top))
                }
                
                ZStack {
                    Rectangle()
                        .cornerRadius(35)
                        .foregroundStyle(.ultraThinMaterial)
                        .shadow(radius: 1)
                    VStack {
                        HStack(spacing: 6) {
                            ForEach(weekDays.indices, id: \.self) { index in
                                Text(selectedDay == index ? weekDays[index] : String(weekDays[index].prefix(1)))
                                    .font(.system(size: selectedDay == index ? 15 : 10))
                                    .bold()
                                    .foregroundStyle(selectedDay == index ? LinearGradient(colors: [.greenEnd, .green, .greenEnd], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [.secondary], startPoint: .leading, endPoint: .trailing))
                                    .padding(.horizontal, 8)
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
                        }
                        TabView(selection: $selectedDay) {
                            ForEach(weekDays.indices, id: \.self) { index in
                                ExercisePlanDayView(exercises: exercises.filter({ $0.weekday == selectedDay }), isEditing: .constant(true), isExpanded: .constant(false), selectedDay: selectedDay)
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .onAppear {
                            UIScrollView.appearance().isScrollEnabled = false
                        }
                        .padding(.horizontal)
                        .mask {
                            Rectangle()
                                .cornerRadius(35)
                        }
                    }
                }
                .padding(.horizontal, 8)
                
                Spacer()
                
                
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation(.easeInOut) {
                        onboardingProgress = 1
                        onboardingGradient = LinearGradient(colors: [.greenStart, .blueEnd, .orangeStart, .purpleEnd], startPoint: .leading, endPoint: .trailing)
                        appState = "navigationTutorial"
                    }
                }, label: {
                    Text("Tap Here When Finished")
                        .font(.body)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.blueEnd)
                        .padding(5)
                        .id("InstructionText")
                        .zIndex(1)
                })
                .background {
                    Rectangle()
                        .cornerRadius(5)
                        .foregroundStyle(.baseAccent)
                }
                .padding(.vertical, 30)
                .buttonStyle(.plain)
            }
            .padding(.top, 60)
        }
        .onAppear {
            getCurrentWeekday()
            
            animateText()
        }
        
    }
    
    private func getCurrentWeekday() {
        let currentDate = Date()
        let calendar = Calendar.current
        if let dayOfWeek = calendar.dateComponents([.weekday], from: currentDate).weekday {
            self.selectedDay = dayOfWeek - 1
        } else {
            self.selectedDay = 1
        }
    }

    private func animateText() {
        withAnimation(.easeInOut(duration: 2)) {
            showText = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                withAnimation {
                    showMoreText = true
                }
            }
        }
    }
}

#Preview {
    GoalSetView(onboardingProgress: .constant(0.75), onboardingGradient: .constant(LinearGradient(colors: [.greenStart, .blueEnd, .orangeStart], startPoint: .leading, endPoint: .trailing)))
}
