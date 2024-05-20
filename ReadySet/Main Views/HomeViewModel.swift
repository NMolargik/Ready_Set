//
//  HomeViewModel.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/11/24.
//

import SwiftUI
import HealthKit

class HomeViewModel: ObservableObject {
    static let shared = HomeViewModel()

    @AppStorage("lastUseDate", store: UserDefaults(suiteName: Bundle.main.groupID)) var lastUseDate: String = "2024-04-19"
    @AppStorage("appState", store: UserDefaults(suiteName: Bundle.main.groupID)) var appState: String = "background"
    @AppStorage("useMetric", store: UserDefaults(suiteName: Bundle.main.groupID)) var useMetric: Bool = false

    @Published var selectedTab: any ITabItem = ExerciseTabItem()
    @Published var navigationDragHeight = 0.0
    @Published var selectedDay: Int = 1 {
        didSet {
            withAnimation {
                self.navigationDragHeight = 0.0
            }
        }
    }

    init() {

    }

    var tabItems = TabItemType.allItems

    func handleDragEnd(navigationDragHeight: CGFloat) {
        if navigationDragHeight < -100 {
            self.selectedTab = self.selectedTab.bumpTab(up: false)
            self.tabItems = self.selectedTab.reorderTabs()
        }

        if navigationDragHeight > 50 {
            self.selectedTab = self.selectedTab.bumpTab(up: true)
            self.tabItems = self.selectedTab.reorderTabs()
        }
    }

    func needRefreshFromDate() -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let dateOnly = calendar.date(from: dateComponents) {
            let formattedDate = dateFormatter.string(from: dateOnly)
            print("Last Date: \(lastUseDate) | Current Date: \(formattedDate)")
            if formattedDate != lastUseDate {
                lastUseDate = formattedDate
                return true
            }
        } else {
            print("Failed to remove time from the current date")
        }
        return false
    }

    var backgroundGradient: LinearGradient {
        LinearGradient(colors: [.base, .base, selectedTab.color],
                       startPoint: .top, endPoint: .bottom)
    }

    var effectiveBlurRadius: CGFloat {
        abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.03) : 0
    }

    func dragGesture(exerciseViewModel: ExerciseViewModel) -> some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged { value in
                if (!exerciseViewModel.editingSets && !exerciseViewModel.expandedSets) || self.selectedTab.type != .exercise {
                    self.navigationDragHeight = value.translation.height
                } else {
                    self.navigationDragHeight = 0.0
                }
            }
            .onEnded { _ in
                if (!exerciseViewModel.editingSets && !exerciseViewModel.expandedSets) || self.selectedTab.type != .exercise {
                    withAnimation(.smooth) {
                        self.handleDragEnd(navigationDragHeight: self.navigationDragHeight)
                        self.navigationDragHeight = 0.0
                    }
                } else {
                    self.navigationDragHeight = 0.0
                }
            }
    }

    func progressForSelectedTab(exerciseViewModel: ExerciseViewModel, waterViewModel: WaterViewModel, energyViewModel: EnergyViewModel) -> Binding<Double> {
        switch selectedTab.type {
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

    func setupViewModels(healthStore: HKHealthStore, exerciseViewModel: ExerciseViewModel, waterViewModel: WaterViewModel, energyViewModel: EnergyViewModel, watchConnector: WatchConnector) {
        exerciseViewModel.healthStore = healthStore
        waterViewModel.healthStore = healthStore
        energyViewModel.healthStore = healthStore

        exerciseViewModel.watchConnector = watchConnector
        waterViewModel.watchConnector = watchConnector
        energyViewModel.watchConnector = watchConnector

        if needRefreshFromDate() {
            exerciseViewModel.readInitial()
            waterViewModel.readInitial()
            energyViewModel.readInitial()

            watchConnector.sendUpdateToWatch(update: ["stepBalance": exerciseViewModel.stepsToday, "waterBalance": waterViewModel.waterConsumedToday, "energyBalance": energyViewModel.energyConsumedToday])
        }
    }

    func setupConnectorClosures(watchConnector: WatchConnector, exerciseViewModel: ExerciseViewModel, waterViewModel: WaterViewModel, energyViewModel: EnergyViewModel) {
        watchConnector.addConsumption = { entryType, consumption in
            if entryType == .water {
                withAnimation {
                    waterViewModel.addWater(waterToAdd: Double(consumption))
                }
            } else {
                withAnimation {
                    energyViewModel.addEnergy(energy: Double(consumption))
                }
            }
        }

        watchConnector.sendUpdateToWatch(update: ["appState": "background"])
    }

    func handleMetricChange(watchConnector: WatchConnector, waterViewModel: WaterViewModel, energyViewModel: EnergyViewModel) {
        watchConnector.sendUpdateToWatch(update: ["useMetric": self.useMetric])
        setGoalsAfterUnitChange(waterViewModel: waterViewModel, energyViewModel: energyViewModel)
    }

    func setGoalsAfterUnitChange(waterViewModel: WaterViewModel, energyViewModel: EnergyViewModel) {
        withAnimation {
            if self.useMetric {
                waterViewModel.waterGoal = Double(Float(waterViewModel.waterGoal) * 29.5735).rounded()
                energyViewModel.energyGoal = Double(Float(energyViewModel.energyGoal) * 4.184).rounded()
            } else {
                waterViewModel.waterGoal = Double(Float(waterViewModel.waterGoal) / 29.5735).rounded()
                energyViewModel.energyGoal = Double(Float(energyViewModel.energyGoal) / 4.184).rounded()
            }
        }
    }

    func handleScenePhase(newPhase: ScenePhase, exerciseViewModel: ExerciseViewModel, waterViewModel: WaterViewModel, energyViewModel: EnergyViewModel, watchConnector: WatchConnector) {
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

        print(appState)
        watchConnector.sendUpdateToWatch(update: ["appState": appState])
    }

    func handleOpenURL(url: URL) {
        print("Handling URL: \(url.absoluteString)")
        switch url.host {
        case "exercise":
            print("Navigating to Exercise tab")
            selectedTab = ExerciseTabItem()
        case "water":
            print("Navigating to Water tab")
            selectedTab = WaterTabItem()
        case "energy":
            print("Navigating to Energy tab")
            selectedTab = EnergyTabItem()
        default:
            print("Unknown URL: \(url.absoluteString)")
            break
        }
    }

    func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem) {
        print(shortcutItem.type)
        switch shortcutItem.type {
        case "Exercise":
            selectedTab = ExerciseTabItem()
        case "Water":
            selectedTab = WaterTabItem()
        case "Energy":
            selectedTab = EnergyTabItem()
        default:
            selectedTab = ExerciseTabItem()
        }
    }
}
