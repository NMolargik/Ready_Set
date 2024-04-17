//
//  MainView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI
import CoreData

struct MainView: View {
    @AppStorage("appState") var appState: String = "splash"
        var healthController = HealthBaseController()
        
        @State var color: Color = .clear
        
        var body: some View {
            ZStack {
                contentView(for: appState)
                    .animation(.easeInOut, value: appState)
                    .transition(.opacity)
                
                onboardingOverlay()
            }
            .transition(.opacity)
            .onAppear(perform: handleAppear)
            .ignoresSafeArea()
        }
        
        @ViewBuilder
        private func contentView(for appState: String) -> some View {
            switch appState {
            case "splash":
                SplashView(color: $color)
                    .transition(.opacity)
            case "register":
                UserRegistrationView(color: $color)
                    .transition(.opacity)
            case "goalSetting":
                GoalSetView(color: $color)
                    .onAppear(perform: healthController.requestAuthorization)
                    .transition(.opacity)
            case "navigationTutorial":
                NavigationTutorialView(color: $color)
                    .transition(.opacity)
            default:
                HomeView(healthStore: healthController.healthStore)
                    .transition(.push(from: .bottom))
            }
        }
        
        @ViewBuilder
        private func onboardingOverlay() -> some View {
            if appState != "running" {
                VStack {
                    Rectangle()
                        .foregroundStyle(LinearGradient(colors: [color, .clear, .clear], startPoint: .top, endPoint: .bottom))
                        .frame(height: 200)
                        .id("OnboardingHeader")
                    Spacer()
                }
            }
        }
        
        private func handleAppear() {
            if appState != "running" {
                appState = "splash"
            }
        }
}

#Preview {
    MainView()
}
