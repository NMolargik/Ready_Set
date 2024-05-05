//
//  HomeView.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var mainWatchViewModel: MainWatchViewModel
    @ObservedObject var phoneConnector: PhoneConnector

    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $mainWatchViewModel.selectedTab) {
                    if mainWatchViewModel.appState != "running" && mainWatchViewModel.appState != "background" {
                        OnboardingView(appState: $mainWatchViewModel.appState)
                            .containerBackground(LinearGradient(colors: [.purpleStart, .purpleEnd], startPoint: .leading, endPoint: .trailing), for: .tabView)
                            .transition(.opacity)
                            .tag(0)
                    } else {
                        WatchTrackerView(
                            title: "Exercise",
                            unit: "steps",
                            gradient: ExerciseTabItem().gradient,
                            color: ExerciseTabItem().color,
                            iconName: "footprint.fill",
                            systemIconName: "plus",
                            min: 0,
                            currentBalance: $mainWatchViewModel.stepBalance,
                            goal: $mainWatchViewModel.stepGoal,
                            step: 0,
                            useMetric: false,
                            addIntake: { steps, completion in
                                return
                            },
                            requestBalanceUpdate: {
                                withAnimation {
                                    phoneConnector.requestValuesFromPhone(values: ["giveStepBalance"]) { response in
                                        mainWatchViewModel.processPhoneUpdate(update: response)
                                    }
                                }
                            }
                        )
                        .tag(0)
                        .containerBackground(ExerciseTabItem().gradient, for: .tabView)

                        WatchTrackerView(
                            title: "Water",
                            unit: mainWatchViewModel.useMetric ? "mL" : "oz",
                            gradient: WaterTabItem().gradient,
                            color: WaterTabItem().color,
                            iconName: "Droplet",
                            systemIconName: "plus",
                            min: mainWatchViewModel.useMetric ? 150 : 8,
                            currentBalance: $mainWatchViewModel.waterBalance,
                            goal: $mainWatchViewModel.waterGoal,
                            step: mainWatchViewModel.useMetric ? 50 : 8,
                            useMetric: mainWatchViewModel.useMetric,
                            addIntake: { water, completion in
                                phoneConnector.sendNewIntakeToPhone(intake: water, entryType: .water) { success in
                                    completion(success)
                                }
                            },
                            requestBalanceUpdate: {
                                withAnimation {
                                    phoneConnector.requestValuesFromPhone(values: ["giveWaterBalance"]) { response in
                                        mainWatchViewModel.processPhoneUpdate(update: response)
                                    }
                                }
                            }
                        )
                        .tag(1)
                        .containerBackground(WaterTabItem().gradient, for: .tabView)

                        WatchTrackerView(
                            title: "Energy",
                            unit: mainWatchViewModel.useMetric ? "kJ" : "cal",
                            gradient: EnergyTabItem().gradient,
                            color: EnergyTabItem().color,
                            iconName: "Flame",
                            systemIconName: "plus",
                            min: mainWatchViewModel.useMetric ? 4184 : 1000,
                            currentBalance: $mainWatchViewModel.energyBalance,
                            goal: $mainWatchViewModel.energyGoal,
                            step: 100,
                            useMetric: mainWatchViewModel.useMetric,
                            addIntake: { energy, completion in
                                phoneConnector.sendNewIntakeToPhone(intake: energy, entryType: .energy) { success in
                                    completion(success)
                                }
                            },
                            requestBalanceUpdate: {
                                withAnimation {
                                    phoneConnector.requestValuesFromPhone(values: ["giveEnergyBalance"]) { response in
                                        mainWatchViewModel.processPhoneUpdate(update: response)
                                    }
                                }
                            }
                        )
                        .tag(2)
                        .containerBackground(EnergyTabItem().gradient, for: .tabView)
                    }
                }
                .tabViewStyle(.verticalPage(transitionStyle: .blur))
                .zIndex(2)
            }
        }
        .onAppear {
            withAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    mainWatchViewModel.getInitialValues(connector: phoneConnector)
                }
            }
        }
    }
}

#Preview {
    HomeView(mainWatchViewModel: MainWatchViewModel(), phoneConnector: PhoneConnector())
}
