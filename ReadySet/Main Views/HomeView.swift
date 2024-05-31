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

    @StateObject var homeViewModel: HomeViewModel = .shared
    @StateObject var exerciseViewModel: ExerciseViewModel = .shared
    @StateObject var waterViewModel: WaterViewModel = .shared
    @StateObject var energyViewModel: EnergyViewModel = .shared
    @ObservedObject var watchConnector: WatchConnector = .shared

    @State var healthStore: HKHealthStore

    var body: some View {
        VStack {
            HeaderView(
                progress: homeViewModel.progressForSelectedTab(exerciseViewModel: exerciseViewModel, waterViewModel: waterViewModel, energyViewModel: energyViewModel),
                selectedTab: $homeViewModel.selectedTab
            )
            .padding(.bottom, 15)
            .zIndex(2)

            if !exerciseViewModel.editingSets {
                NavColumnView(exerciseViewModel: exerciseViewModel,
                              waterViewModel: waterViewModel, energyViewModel: energyViewModel,
                              tabItems: $homeViewModel.tabItems, selectedTab: $homeViewModel.selectedTab,
                              navigationDragHeight: $homeViewModel.navigationDragHeight)
                .transition(.opacity)
                .zIndex(1)
            }

            BottomView(
                exerciseViewModel: exerciseViewModel,
                waterViewModel: waterViewModel,
                energyViewModel: energyViewModel,
                selectedTab: $homeViewModel.selectedTab,
                selectedDay: $homeViewModel.selectedDay,
                blurRadius: $homeViewModel.effectiveBlurRadius,
                offset: $homeViewModel.navigationDragHeight,
                dragGesture: AnyGesture(homeViewModel.dragGesture()
                )
            )
            .padding(.top, exerciseViewModel.editingSets ? 0 : 8)
            .padding(.bottom, 30)
            .padding(.horizontal, 8)
            .zIndex(3)

        }
        .background(homeViewModel.backgroundGradient)
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
}

#Preview {
    HomeView(healthStore: HKHealthStore())
        .ignoresSafeArea()
}
