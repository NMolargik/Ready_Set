//
//  OnboardingView.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import SwiftUI
import HealthKit

struct OnboardingView: View {
    @AppStorage("watchOnboardingComplete") var watchOnboardingComplete = false
    
    @Binding var appState: String
    //@Binding var healthController: HealthBaseController
    
    @State private var showText = false
    @State private var swiped = false
    @State private var navigationDragHeight = 0.0
    
    var body: some View {
        ZStack {
            VStack {
                Text("Hello")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(.fontGray)
                    .id("SplashText")
                
                if (showText) {
                    HStack {
                        Image(systemName: "iphone.gen3")
                            .font(.largeTitle)
                            .foregroundStyle(LinearGradient(colors: [.greenStart, .greenEnd], startPoint: .leading, endPoint: .trailing))
                        
                        Text("Searching for Ready, Set...")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.fontGray)
                            .id("InstructionText")
                            .lineLimit(4)
                            .animation(.easeInOut, value: showText)
                            .frame(height: 100)
                    }
                    
                    ProgressView()
                        .tint(.greenEnd)
                }
            }
        }
        .blur(radius: effectiveBlurRadius())
        .gesture(dragGesture)
        .onAppear {
            animateTextAppearance()
            //TODO
            //healthController.requestAuthorization()
        }
    }
    
    private func animateTextAppearance() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut(duration: 1.2)) {
                showText = true
            }
        }
    }
    
    private func effectiveBlurRadius() -> CGFloat {
        abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.03) : 0
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged { value in
                navigationDragHeight = value.translation.height
            }
            .onEnded { value in
                withAnimation(.easeInOut) {
                    handleDragEnd(navigationDragHeight: value.translation.height)
                    navigationDragHeight = 0
                }
            }
    }
    
    private func handleDragEnd(navigationDragHeight: CGFloat) {
        if navigationDragHeight < 50 {
            withAnimation(.easeInOut) {
                watchOnboardingComplete = true
            }
        }
    }
}

#Preview {
    OnboardingView(appState: .constant("running"))
}
