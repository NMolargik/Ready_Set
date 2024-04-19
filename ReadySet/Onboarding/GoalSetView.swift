//
//  GoalSetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI


    //TODO: fix this page!
struct GoalSetView: View {
    @AppStorage("appState") var appState: String = "goalSetting"
    @Binding var onboardingProgress: Float
    @Binding var onboardingGradient: LinearGradient
    
    @State private var showText = false
    @State private var showMoreText = false
    @State private var navigationDragHeight = 0.0
    @State var selectedDay = 1
    
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
                
                HStack(spacing: 6) {
                    ForEach(weekDays.indices, id: \.self) { index in
                        Text(selectedDay == index ? weekDays[index] : String(weekDays[index].prefix(1)))
                            .font(.system(size: selectedDay == index ? 15 : 10))
                            .bold()
                            .foregroundStyle(selectedDay == index ? LinearGradient(colors: [.greenEnd, .green, .greenEnd], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [.secondary], startPoint: .leading, endPoint: .trailing))
                            .padding(.horizontal, 8)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedDay = index
                                }
                            }
                            .animation(.bouncy, value: selectedDay)
                            .zIndex(selectedDay == index ? 2 : 1)
                            .transition(.opacity)
                    }
                }
                .padding(.horizontal, 10)
                
                ZStack {
                    Rectangle()
                        .cornerRadius(35)
                        .foregroundStyle(.ultraThinMaterial)
                        .shadow(radius: 1)
                    
                    TabView(selection: $selectedDay) {
                        ForEach(weekDays.indices, id: \.self) { index in
                            ExercisePlanDayView(selectedDay: $selectedDay.wrappedValue, isEditing: .constant(true), isExpanded: .constant(false))
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .onAppear {
                        UIScrollView.appearance().isScrollEnabled = false
                    }
                    .padding(5)
                    .padding(.vertical, 10)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 40)
                
                Spacer()
                
                Text("Swipe Upwards On The Canvas When Ready")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.fontGray)
                    .id("InstructionText")
                    .zIndex(1)

            }
            .padding(.top, 60)
            .padding(.bottom, 30)
            .blur(radius: blurRadiusForDrag())
        }
        .gesture(dragGesture)
        .onAppear(perform: animateText)
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
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged { value in navigationDragHeight = value.translation.height }
            .onEnded { value in
                withAnimation(.easeInOut) {
                    handleDragEnd(navigationDragHeight: value.translation.height)
                    navigationDragHeight = 0.0
                }
            }
    }
    
    private func blurRadiusForDrag() -> CGFloat {
        abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.03) : 0
    }
    
    private func handleDragEnd(navigationDragHeight: CGFloat) {
        if navigationDragHeight < 50 {
            withAnimation(.easeInOut) {
                onboardingProgress = 1
                onboardingGradient = LinearGradient(colors: [.greenStart, .blueEnd, .orangeStart, .purpleEnd], startPoint: .leading, endPoint: .trailing)
                appState = "navigationTutorial"
            }
        }
    }
}

#Preview {
    GoalSetView(onboardingProgress: .constant(0.75), onboardingGradient: .constant(LinearGradient(colors: [.greenStart, .blueEnd, .orangeStart], startPoint: .leading, endPoint: .trailing)))
}
