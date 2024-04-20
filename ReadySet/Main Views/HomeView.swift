//
//  HomeView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI
import HealthKit

struct HomeView: View {
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("useMetric") var useMetric: Bool = false

    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var exerciseViewModel = ExerciseViewModel()
    @StateObject var waterViewModel = WaterViewModel()
    @StateObject var energyViewModel = EnergyViewModel()

    @State private var navigationDragHeight = 0.0
    @State var healthStore: HKHealthStore

    var body: some View {
        VStack {
            HeaderView(
                progress: progressForSelectedTab,
                selectedTab: $homeViewModel.selectedTab
            )
            .padding(.bottom, 15)
            .zIndex(2)
            
            if ((!exerciseViewModel.editingSets && !exerciseViewModel.expandedSets) || homeViewModel.selectedTab.type != .exercise) {
                NavColumnView(exerciseViewModel: exerciseViewModel,
                              waterViewModel: waterViewModel, energyViewModel: energyViewModel,
                              tabItems: $homeViewModel.tabItems, selectedTab: $homeViewModel.selectedTab,
                              navigationDragHeight: $navigationDragHeight)
                .transition(.opacity)
                .zIndex(1)
            }
                
            BottomView(exerciseViewModel: exerciseViewModel, waterViewModel: waterViewModel, energyViewModel: energyViewModel,
                       selectedTab: $homeViewModel.selectedTab)
                .blur(radius: effectiveBlurRadius)
                .padding(.top, (exerciseViewModel.expandedSets || exerciseViewModel.editingSets) ? 0 : 8)
                .padding(.bottom, 30)
                .padding(.horizontal, 8)
                .zIndex(3)
                
        }
        .background(backgroundGradient)
        .gesture(dragGesture)
        .onAppear(perform: setupViewModels)
        .onChange(of: scenePhase) {
            handleScenePhase(newPhase: scenePhase)
        }
        .onChange(of: useMetric) {
            setGoalsAfterUnitChange()
        }
    }

    private var progressForSelectedTab: Binding<Double> {
        switch homeViewModel.selectedTab.type {
        case .exercise:
            return .constant(Double(exerciseViewModel.stepsToday) / exerciseViewModel.stepGoal)
        case .water:
            return .constant(Double(waterViewModel.waterConsumedToday) / waterViewModel.waterGoal)
        case .Energy:
            return .constant(Double(energyViewModel.energyConsumedToday) / energyViewModel.energyGoal)
        case .settings:
            return .constant(1.0)
        }
    }

    private var backgroundGradient: LinearGradient {
        LinearGradient(colors: [.base, .base, homeViewModel.selectedTab.color],
                       startPoint: .top, endPoint: .bottom)
    }

    private var effectiveBlurRadius: CGFloat {
        abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.03) : 0
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged { value in
                if (!exerciseViewModel.editingSets || homeViewModel.selectedTab.type != .exercise) {
                    navigationDragHeight = value.translation.height
                }
            }
            .onEnded { value in
                if (!exerciseViewModel.editingSets || homeViewModel.selectedTab.type != .exercise) {
                    withAnimation(.smooth) {
                        homeViewModel.handleDragEnd(navigationDragHeight: navigationDragHeight)
                        navigationDragHeight = 0.0
                    }
                }
            }
    }

    private func setupViewModels() {
        if exerciseViewModel.healthStore == nil {
            exerciseViewModel.healthStore = healthStore
        }
        
        if waterViewModel.healthStore == nil {
            waterViewModel.healthStore = healthStore
        }
        
        if energyViewModel.healthStore == nil {
            energyViewModel.healthStore = healthStore
        }
        
        if homeViewModel.needRefreshFromDate() {
            exerciseViewModel.readInitial()
            waterViewModel.readInitial()
            energyViewModel.readInitial()
        }
    }
    
    private func setGoalsAfterUnitChange() {
        withAnimation {
            if useMetric {
                waterViewModel.waterGoal = Double(Float(waterViewModel.waterGoal) * 29.5735).rounded()
                energyViewModel.energyGoal = Double(Float(energyViewModel.energyGoal) * 4.184).rounded()
            } else {
                waterViewModel.waterGoal = Double(Float(waterViewModel.waterGoal) / 29.5735).rounded()
                energyViewModel.energyGoal = Double(Float(energyViewModel.energyGoal) / 4.184).rounded()
            }
        }
    }

    private func handleScenePhase(newPhase: ScenePhase) {
        navigationDragHeight = 0
        if newPhase == .active {
            withAnimation {
                exerciseViewModel.readInitial()
                waterViewModel.readInitial()
                energyViewModel.readInitial()
            }
        }
        
        withAnimation {
            exerciseViewModel.readInitial()
            waterViewModel.readInitial()
            energyViewModel.readInitial() 
        }
    }
}

#Preview {
    HomeView(healthStore: HKHealthStore())
        .ignoresSafeArea()
}
