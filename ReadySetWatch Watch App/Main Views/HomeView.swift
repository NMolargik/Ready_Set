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
                    if (mainWatchViewModel.appState != "running" && mainWatchViewModel.appState != "background") {
                        OnboardingView(appState: $mainWatchViewModel.appState)
                            .containerBackground(LinearGradient(colors: [.purpleStart, .purpleEnd], startPoint: .leading, endPoint: .trailing), for: .tabView)
                            .transition(.opacity)
                            .tag(0)
                    } else {
                        WatchExerciseView(stepsTaken: $mainWatchViewModel.stepBalance, stepGoal: $mainWatchViewModel.stepGoal)
                            .tag(0)
                            .containerBackground(WatchExerciseTabItem().gradient, for: .tabView)
                        
                        WatchWaterView(waterBalance: $mainWatchViewModel.waterBalance, waterGoal: $mainWatchViewModel.waterGoal, useMetric: $mainWatchViewModel.useMetric, addWaterIntake: { water, completion in
                            phoneConnector.sendNewIntakeToPhone(intake: water, entryType: .water) { success in
                                completion(success)
                            }
                        }, requestWaterBalanceUpdate: {
                            withAnimation {
                                phoneConnector.requestValuesFromPhone(values: ["giveWaterBalance"]) { response in
                                    mainWatchViewModel.processPhoneUpdate(update: response)
                                }
                            }
                        })
                        .tag(1)
                        .containerBackground(WatchWaterTabItem().gradient, for: .tabView)
                        
                        WatchEnergyView(energyBalance: $mainWatchViewModel.energyBalance, energyGoal: $mainWatchViewModel.energyGoal, useMetric: $mainWatchViewModel.useMetric, addEnergyIntake: { energy, completion in
                            phoneConnector.sendNewIntakeToPhone(intake: energy, entryType: .energy) { success in
                                completion(success)
                            }
                        }, requestEnergyBalanceUpdate: {
                            withAnimation {
                                phoneConnector.requestValuesFromPhone(values: ["giveEnergyBalance"]) { response in
                                    mainWatchViewModel.processPhoneUpdate(update: response)
                                }
                            }
                        })
                        .tag(2)
                        .containerBackground(WatchEnergyTabItem().gradient, for: .tabView)
                    }
                }
                .tabViewStyle(.verticalPage(transitionStyle: .blur))
                .zIndex(2)
            }
            
        }
        .onAppear {
            withAnimation {
                mainWatchViewModel.getInitialValues(connector: phoneConnector)
            }
        }
    }
}

#Preview {
    HomeView(mainWatchViewModel: MainWatchViewModel(), phoneConnector: PhoneConnector())
}
