//
//  MainView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI
import Foundation

struct MainView: View {
    @AppStorage("appState") var appState: String = "splash"
    
    @State private var color: Color = .clear
    @State private var onboardingProgress : Float = 0.0
    @State private var onboardingGradient = LinearGradient(colors: [.clear, .clear], startPoint: .leading, endPoint: .trailing)
    
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
        .onAppear {
            if appState != "running" {
                withAnimation {
                    onboardingProgress = 0.25
                    onboardingGradient = LinearGradient(colors: [.greenStart, .greenEnd], startPoint: .leading, endPoint: .trailing)
                    appState = "splash"
                }
            }
        }
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
                .animation(.easeInOut, value: appState)
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
                                .foregroundStyle(.baseAccent)
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
