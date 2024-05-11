//
//  GoalSetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/28/24.
//

import SwiftUI

struct GoalSetView: View {
    @AppStorage("appState", store: UserDefaults(suiteName: Bundle.main.groupID)) var appState: String = "goalSetView"
    @AppStorage("stepGoal", store: UserDefaults(suiteName: Bundle.main.groupID)) var stepGoal: Double = 1000
    @AppStorage("waterGoal", store: UserDefaults(suiteName: Bundle.main.groupID)) var waterGoal: Double = 64
    @AppStorage("energyGoal", store: UserDefaults(suiteName: Bundle.main.groupID)) var energyGoal: Double = 2000
    @AppStorage("useMetric", store: UserDefaults(suiteName: Bundle.main.groupID)) var useMetric: Bool = false
    
    @Binding var onboardingProgress: Float
    @Binding var onboardingGradient: LinearGradient
    
    @State private var showText = false
    @State private var showMoreText = false
    @State private var navigationDragHeight = 0.0
    @State private var stepSliderValue: Double = 0
    @State private var waterSliderValue: Double = 0
    @State private var energySliderValue: Double = 0
    
    var body: some View {
        ZStack {
            Color.base
            
            VStack {
                Spacer()
                
                if showText {
                    Text("Let's Set Your Goals")
                        .bold()
                        .font(.system(size: 40))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.fontGray)
                        .id("GoalText")
                        .padding(.bottom, showMoreText ? 0 : 30)
                }

                if showMoreText {
                    Toggle(isOn: $useMetric, label: {
                        Text("Use Metric Units")
                    })
                    .padding(.horizontal)
                    .foregroundStyle(.fontGray)
                    
                    SliderView(range: 1000...15000, gradient: ExerciseTabItem().gradient, step: 1000, label: "daily steps", sliderValue: $stepSliderValue)
                        .onChange(of: stepSliderValue) {
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        }
                        .onAppear {
                            stepSliderValue = stepGoal
                        }
                        .frame(height: 90)
                    
                    SliderView(range: (useMetric ? 150 : 8)...(useMetric ? 4000 : 168), gradient: WaterTabItem().gradient, step: useMetric ? 50 : 8, label: useMetric ? "daily mL" : "daily ounces", sliderValue: $waterSliderValue)
                        .onAppear {
                            waterSliderValue = waterGoal
                        }
                        .onChange(of: waterSliderValue) {
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        }
                        .frame(height: 90)
                    
                    SliderView(range: (useMetric ? 4184 : 1000)...(useMetric ? 20920 : 5000), gradient: EnergyTabItem().gradient, step: 100, label: useMetric ? "daily kJ" : "daily calories", sliderValue: $energySliderValue)
                        .onAppear {
                            energySliderValue = energyGoal
                        }
                        .onChange(of: energySliderValue) {
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        }
                        .onChange(of: useMetric) {
                            setGoalsAfterUnitChange()
                        }
                        .frame(height: 90)
                    }

                    Spacer()
                        
                    Text("Swipe Upwards On The Canvas When Finished")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.fontGray)
                        .id("InstructionText")
                        .zIndex(1)
                    }
                    .onAppear(perform: animateTextAppearance)
                    .blur(radius: effectiveBlurRadius())
                    .transition(.opacity)
                    .padding(.bottom, 30)
        }
        .gesture(dragGesture)

    }
    
    private func animateTextAppearance() {
        withAnimation(.easeInOut(duration: 1.2)) {
            showText = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut(duration: 1.2)) {
                showMoreText = true
            }
        }
    }
    
    private func setGoalsAfterUnitChange() {
        withAnimation {
            if useMetric {
                waterGoal = Double(Float(waterGoal) * 29.5735).rounded()
                waterSliderValue = waterGoal
                energyGoal = Double(Float(energyGoal) * 4.184).rounded()
                energySliderValue = energyGoal
            } else {
                waterGoal = Double(Float(waterGoal) / 29.5735).rounded()
                waterSliderValue = waterGoal
                energyGoal = Double(Float(energyGoal) / 4.184).rounded()
                energySliderValue = energyGoal
            }
        }
    }
    
    private func effectiveBlurRadius() -> CGFloat {
        abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.03) : 0
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged { value in
                navigationDragHeight = value.translation.height
            }
            .onEnded { value in
                withAnimation(.easeInOut) {
                    if showMoreText {
                        handleDragEnd(navigationDragHeight: value.translation.height)
                    }
                    navigationDragHeight = 0
                }
            }
    }
    
    private func handleDragEnd(navigationDragHeight: CGFloat) {
        if navigationDragHeight < 50 {
            withAnimation(.easeInOut) {
                stepGoal = stepSliderValue
                waterGoal = waterSliderValue
                energyGoal = energySliderValue
                onboardingProgress = 1.0
                onboardingGradient = LinearGradient(colors: [.greenStart, .blueEnd, .orangeStart, .purpleEnd], startPoint: .leading, endPoint: .trailing)
                appState = "navigationTutorial"
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }
        }
    }
}


#Preview {
    GoalSetView(onboardingProgress: .constant(0.75), onboardingGradient: .constant(LinearGradient(colors: [.greenStart, .blueEnd, .orangeStart], startPoint: .leading, endPoint: .trailing)))
}
