//
//  MainWatchView.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/22/24.
//

import SwiftUI

struct MainWatchView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var mainWatchViewModel = MainWatchViewModel()
    @StateObject var phoneConnector = PhoneConnector()
    
    //TODO: check every ten seconds for appState from the phone during onboarding
    
    var body: some View {
        VStack {
            if (mainWatchViewModel.appState != "running") {
                OnboardingView(appState: $mainWatchViewModel.appState)
                    .transition(.move(edge: .top))
            } else {
                HomeView(mainWatchViewModel: mainWatchViewModel, phoneConnector: phoneConnector)
                    .transition(.move(edge: .top))
                    .ignoresSafeArea()
            }
        }
        .animation(.easeInOut, value: mainWatchViewModel.appState)
        .onAppear {
            phoneConnector.requestInitialsFromPhone { initialPackage in
                withAnimation {
                    mainWatchViewModel.respondToPhoneUpdate(update: initialPackage)
                }
            }
        }
        .onChange(of: scenePhase) {
            phoneConnector.requestInitialsFromPhone { initialPackage in
                withAnimation {
                    mainWatchViewModel.respondToPhoneUpdate(update: initialPackage)
                }
            }
        }
    }
    
    private func setupConnectorClosures() {
        phoneConnector.respondToPhoneUpdate = mainWatchViewModel.respondToPhoneUpdate(update:)
    }
}

#Preview {
    MainWatchView()
}
