//
//  MainView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct MainView: View {
    @AppStorage("appState") var appState: String = "splash"
    
    @State var color: Color = .clear
    @State var onboardingProgress : Float = 0.0
    @State var onboardingGradient = LinearGradient(colors: [.clear, .clear], startPoint: .leading, endPoint: .trailing)
    
    @State var healthController = HealthBaseController()
    
    var body: some View {
        ZStack {
            contentView(for: appState)
                .animation(.easeInOut, value: appState)
                .transition(.opacity)
            
            onboardingOverlay()
        }
        .transition(.opacity)
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func contentView(for appState: String) -> some View {
        switch appState {
        case "splash":
            SplashView(onboardingProgress: $onboardingProgress, onboardingGradient: $onboardingGradient)
                .transition(.opacity)
        case "healthPermission":
            HealthPermissionView(onboardingProgress: $onboardingProgress, onboardingGradient: $onboardingGradient, healthController: $healthController)
                .transition(.opacity)
        case "goalSetting":
            GoalSetView(onboardingProgress: $onboardingProgress, onboardingGradient: $onboardingGradient)
                .transition(.opacity)
        case "navigationTutorial":
            NavigationTutorialView(onboardingProgress: $onboardingProgress, onboardingGradient: $onboardingGradient)
                .transition(.opacity)
        default:
            HomeView(healthStore: healthController.healthStore)
                .animation(.easeInOut, value: appState)
                .transition(.opacity)
        }
    }
    
    @ViewBuilder
    private func onboardingOverlay() -> some View {
        if appState != "running" {
            VStack {
                GeometryReader { geometry in
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame(height: 60)
                                .foregroundColor(.baseAccent)
                                .shadow(color: .black, radius: 10)
                            
                            Rectangle()
                                .frame(width: min(geometry.size.width * CGFloat(min(onboardingProgress, 1)), geometry.size.width), height: 60)
                                .foregroundStyle(onboardingGradient)
                                .animation(.easeInOut(duration: 1), value: onboardingProgress)
                        }
                    }
                }
                .frame(height: 60)
                
                Spacer()
            }
        }
    }
}

#Preview {
    MainView()
}
