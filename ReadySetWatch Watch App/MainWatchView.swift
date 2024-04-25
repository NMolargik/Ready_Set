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
        ZStack {
            if (mainWatchViewModel.appState == "inoperable") {
                Text("Set up Ready, Set on your phone to continue...")
            }
            
            VStack {
                
            }
        }
        .onAppear {
            setupConnectorClosures()
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
