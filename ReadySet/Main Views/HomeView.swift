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

    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var exerciseViewModel = ExerciseViewModel()
    @StateObject var waterViewModel = WaterViewModel()
    @StateObject var calorieViewModel = CalorieViewModel()

    @State private var navigationDragHeight = 0.0
    @State var healthStore: HKHealthStore

    var body: some View {
        VStack {
            HeaderView(
                progress: progressForSelectedTab,
                selectedTab: $homeViewModel.selectedTab
            )
            .padding(.bottom, 15)
            
            NavColumnView(exerciseViewModel: exerciseViewModel,
                          waterViewModel: waterViewModel, calorieViewModel: calorieViewModel,
                          tabItems: $homeViewModel.tabItems, selectedTab: $homeViewModel.selectedTab,
                          navigationDragHeight: $navigationDragHeight)
            
            BottomView(waterViewModel: waterViewModel, calorieViewModel: calorieViewModel,
                       selectedTab: $homeViewModel.selectedTab)
                .blur(radius: effectiveBlurRadius)
                .padding(.bottom, 15)
        }
        .background(backgroundGradient)
        .gesture(dragGesture)
        .onAppear(perform: setupViewModels)
        .onChange(of: scenePhase, perform: handleScenePhase)
    }

    private var progressForSelectedTab: Binding<Double> {
        switch homeViewModel.selectedTab.type {
        case .exercise:
            return .constant(Double(exerciseViewModel.stepsToday) / exerciseViewModel.stepGoal)
        case .water:
            return .constant(Double(waterViewModel.waterConsumedToday) / waterViewModel.waterGoal)
        case .calorie:
            return .constant(Double(calorieViewModel.caloriesConsumed) / calorieViewModel.calorieGoal)
        case .settings:
            return .constant(1.0)
        }
    }

    private var backgroundGradient: LinearGradient {
        LinearGradient(colors: [.base, .base, homeViewModel.selectedTab.color],
                       startPoint: .top, endPoint: .bottom)
    }

    private var effectiveBlurRadius: CGFloat {
        abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.01) : 0
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged { value in navigationDragHeight = value.translation.height }
            .onEnded { value in
                withAnimation(.smooth) {
                    homeViewModel.handleDragEnd(navigationDragHeight: navigationDragHeight)
                    navigationDragHeight = 0.0
                }
            }
    }

    private func setupViewModels() {
        exerciseViewModel.healthStore = healthStore
        waterViewModel.healthStore = healthStore
        calorieViewModel.healthStore = healthStore
        exerciseViewModel.readInitial()
        waterViewModel.readInitial()
        calorieViewModel.readInitial()
    }

    private func handleScenePhase(newPhase: ScenePhase) {
        if newPhase == .active {
            withAnimation {
                exerciseViewModel.readInitial()
                waterViewModel.readInitial()
                calorieViewModel.readInitial()
            }
        }
    }
}

#Preview {
    HomeView(healthStore: HKHealthStore())
        .ignoresSafeArea()
}
