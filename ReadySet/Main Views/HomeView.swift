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

    @State private var homeViewModel = HomeViewModel()
    @State var exerciseViewModel = ExerciseViewModel.shared
    @State var waterViewModel = WaterViewModel.shared
    @State var energyViewModel = EnergyViewModel.shared
    @State var watchConnector: WatchConnector = .shared

    @State var healthStore: HKHealthStore

    var body: some View {
        VStack {
            HeaderView(
                progress: homeViewModel.progressForSelectedTab(exerciseViewModel: exerciseViewModel, waterViewModel: waterViewModel, energyViewModel: energyViewModel),
                selectedTab: $homeViewModel.selectedTab
            )
            .padding(.bottom, 15)
            .zIndex(2)

            if showNavColumn() {
                NavColumnView(exerciseViewModel: exerciseViewModel,
                              waterViewModel: waterViewModel, energyViewModel: energyViewModel,
                              tabItems: $homeViewModel.tabItems, selectedTab: $homeViewModel.selectedTab,
                              navigationDragHeight: $homeViewModel.navigationDragHeight)
                .transition(.opacity)
                .zIndex(1)
            }

            BottomView(exerciseViewModel: exerciseViewModel, waterViewModel: waterViewModel, energyViewModel: energyViewModel,
                       selectedTab: $homeViewModel.selectedTab, selectedDay: $homeViewModel.selectedDay)
                .blur(radius: homeViewModel.effectiveBlurRadius)
                .padding(.top, (exerciseViewModel.expandedSets || exerciseViewModel.editingSets) ? 0 : 8)
                .padding(.bottom, 30)
                .padding(.horizontal, 8)
                .zIndex(3)

        }
        .background(homeViewModel.backgroundGradient)
        .gesture(homeViewModel.dragGesture(exerciseViewModel: exerciseViewModel))
        .onAppear {
            homeViewModel.setupViewModels(healthStore: healthStore, exerciseViewModel: exerciseViewModel, waterViewModel: waterViewModel, energyViewModel: energyViewModel, watchConnector: watchConnector)
            homeViewModel.setupConnectorClosures(watchConnector: watchConnector, exerciseViewModel: exerciseViewModel, waterViewModel: waterViewModel, energyViewModel: energyViewModel)
        }
        .onChange(of: scenePhase) {
            homeViewModel.handleScenePhase(newPhase: scenePhase, exerciseViewModel: exerciseViewModel, waterViewModel: waterViewModel, energyViewModel: energyViewModel, watchConnector: watchConnector)
        }
        .onChange(of: homeViewModel.useMetric) {
            homeViewModel.handleMetricChange(watchConnector: watchConnector, waterViewModel: waterViewModel, energyViewModel: energyViewModel)
        }
        .onOpenURL { url in
            homeViewModel.handleOpenURL(url: url)
        }
    }

    func showNavColumn() -> Bool {
        return !exerciseViewModel.editingSets && !exerciseViewModel.expandedSets || homeViewModel.selectedTab.type != .exercise
    }
}

#Preview {
    HomeView(healthStore: HKHealthStore())
        .ignoresSafeArea()
}
