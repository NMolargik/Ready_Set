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
    
    var body: some View {
        VStack {
            HomeView(mainWatchViewModel: mainWatchViewModel, phoneConnector: phoneConnector)
                .transition(.move(edge: .bottom))
                .ignoresSafeArea()
        }
        .animation(.easeInOut, value: mainWatchViewModel.appState)
        .onAppear {
            setupConnectorClosures()
            phoneConnector.requestInitialsFromPhone { initialPackage in
                withAnimation {
                    mainWatchViewModel.processPhoneUpdate(update: initialPackage)
                }
            }
        }
        .onChange(of: scenePhase) {
            phoneConnector.requestInitialsFromPhone { initialPackage in
                withAnimation {
                    mainWatchViewModel.processPhoneUpdate(update: initialPackage)
                }
            }
        }
    }
    
    private func setupConnectorClosures() {
        phoneConnector.respondToPhoneUpdate = mainWatchViewModel.processPhoneUpdate(update:)
    }
}

#Preview {
    MainWatchView()
}
