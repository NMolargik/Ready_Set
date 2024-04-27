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
                HeaderView(progress: $mainWatchViewModel.progress, selectedTab: $mainWatchViewModel.selectedTab)
                
                Spacer()
            }
            
            TabView(selection: $mainWatchViewModel.selectedTab) {
                WatchExerciseView(stepsTaken: $mainWatchViewModel.stepsTakenToday, stepGoal: $mainWatchViewModel.stepGoal)
                    .tag(0)
                    .tabItem {
                        tabImage(selectedTab: mainWatchViewModel.selectedTab, tabItem: WatchExerciseTabItem())
                        
                    }
                
                
                WatchWaterView(waterBalance: $mainWatchViewModel.waterBalance, waterGoal: $mainWatchViewModel.waterGoal, useMetric: $mainWatchViewModel.useMetric, addWaterIntake: { water, completion in
                    phoneConnector.sendNewIntakeToPhone(intake: water, entryType: .water) { success in
                        completion(success)
                    }
                }, requestWaterBalanceUpdate: {
                    withAnimation {
                        phoneConnector.requestValuesFromPhone(values: ["giveWaterBalance"]) { response in
                            mainWatchViewModel.respondToPhoneUpdate(update: response)
                        }
                    }
                })
                .tag(1)
                .tabItem {
                    tabImage(selectedTab: mainWatchViewModel.selectedTab, tabItem: WatchWaterTabItem())
                }
                
                WatchEnergyView(energyBalance: $mainWatchViewModel.energyBalance, energyGoal: $mainWatchViewModel.energyGoal, useMetric: $mainWatchViewModel.useMetric, addEnergyIntake: { energy, completion in
                    phoneConnector.sendNewIntakeToPhone(intake: energy, entryType: .energy) { success in
                        completion(success)
                    }
                }, requestEnergyBalanceUpdate: {
                    withAnimation {
                        phoneConnector.requestValuesFromPhone(values: ["giveEnergyBalance"]) { response in
                            mainWatchViewModel.respondToPhoneUpdate(update: response)
                        }
                    }
                })
                .tag(2)
                .tabItem {
                    tabImage(selectedTab: mainWatchViewModel.selectedTab, tabItem: WatchEnergyTabItem())
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            
        }
        .onAppear {
            withAnimation {
                mainWatchViewModel.readStepCountToday()
                mainWatchViewModel.getInitialValues(connector: phoneConnector)
            }
        }
    }
    
    private func tabImage(selectedTab: Int, tabItem: any IWatchTabItem) -> some View {
        Image(tabItem.icon)
            .resizable()
            .renderingMode(selectedTab == WatchTabItemType.allItems.firstIndex(where: {$0.type == tabItem.type}) ? .original : .template)
            .frame(width: selectedTab == WatchTabItemType.allItems.firstIndex(where: {$0.type == tabItem.type}) ? 30 : 20, height: selectedTab == WatchTabItemType.allItems.firstIndex(where: {$0.type == tabItem.type}) ? 30 : 20)
            .foregroundStyle(tabItem.color)
            .colorMultiply(.white)
            .transition(.opacity)
    }
}

#Preview {
    HomeView(mainWatchViewModel: MainWatchViewModel(), phoneConnector: PhoneConnector())
}
