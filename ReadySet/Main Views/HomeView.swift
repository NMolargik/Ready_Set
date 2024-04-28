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
    @AppStorage("appState") var appState: String = "background"

    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var exerciseViewModel = ExerciseViewModel()
    @StateObject var waterViewModel = WaterViewModel()
    @StateObject var energyViewModel = EnergyViewModel()
    
    @StateObject var watchConnector: WatchConnector = WatchConnector()
    
    @State private var navigationDragHeight = 0.0
    @State var healthStore: HKHealthStore
    @State private var selectedDay: Int = 1
    

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
                       selectedTab: $homeViewModel.selectedTab, selectedDay: $selectedDay)
                .blur(radius: effectiveBlurRadius)
                .padding(.top, (exerciseViewModel.expandedSets || exerciseViewModel.editingSets) ? 0 : 8)
                .padding(.bottom, 30)
                .padding(.horizontal, 8)
                .zIndex(3)
                
        }
        .background(backgroundGradient)
        .gesture(dragGesture)
        .onAppear {
            setupViewModels()
            setupConnectorClosures()
        }
        .onChange(of: scenePhase) {
            handleScenePhase(newPhase: scenePhase)
        }
        .onChange(of: useMetric) {
            setGoalsAfterUnitChange()
        }
        .onChange(of: selectedDay) {
            withAnimation {
                navigationDragHeight = 0.0
            }
        }
    }

    private var progressForSelectedTab: Binding<Double> {
        switch homeViewModel.selectedTab.type {
        case .exercise:
            return .constant(Double(exerciseViewModel.stepsToday) / exerciseViewModel.stepGoal)
        case .water:
            return .constant(Double(waterViewModel.waterConsumedToday) / waterViewModel.waterGoal)
        case .energy:
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
                if ((!exerciseViewModel.editingSets && !exerciseViewModel.expandedSets) || homeViewModel.selectedTab.type != .exercise) {
                    navigationDragHeight = value.translation.height
                } else {
                    navigationDragHeight = 0.0
                }
            }
            .onEnded { value in
                if ((!exerciseViewModel.editingSets && !exerciseViewModel.expandedSets) || homeViewModel.selectedTab.type != .exercise) {
                    withAnimation(.smooth) {
                        homeViewModel.handleDragEnd(navigationDragHeight: navigationDragHeight)
                        navigationDragHeight = 0.0
                    }
                } else {
                    navigationDragHeight = 0.0
                }
            }
    }

    private func setupViewModels() {
        exerciseViewModel.healthStore = healthStore
        waterViewModel.healthStore = healthStore
        energyViewModel.healthStore = healthStore

        if homeViewModel.needRefreshFromDate() {
            exerciseViewModel.readInitial()
            waterViewModel.readInitial()
            energyViewModel.readInitial()
        }
        
        exerciseViewModel.watchConnector = watchConnector
        waterViewModel.watchConnector = watchConnector
        energyViewModel.watchConnector = watchConnector
    }
    
    private func setupConnectorClosures() {
        watchConnector.requestWaterConsumptionBalance = {
            return waterViewModel.waterConsumedToday
        }
        
        watchConnector.requestEnergyConsumptionBalance = {
            return energyViewModel.energyConsumedToday
        }
        
        watchConnector.addConsumption = { entryType, consumption in
            if (entryType == .water) {
                withAnimation {
                    waterViewModel.addWater(waterToAdd: Double(consumption))
                }
            } else {
                withAnimation {
                    energyViewModel.addEnergy(energy: Double(consumption))
                }
            }
        }
        
        watchConnector.sendUpdateToWatch(update: ["appState" : "running"])
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
            appState = "running"
            withAnimation {
                exerciseViewModel.readInitial()
                waterViewModel.readInitial()
                energyViewModel.readInitial()
            }
        } else {
            appState = "background"
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
