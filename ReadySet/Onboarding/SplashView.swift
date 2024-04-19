//
//  SplashView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI

struct SplashView: View {
    @AppStorage("appState") var appState: String = "splash"
    @Binding var onboardingProgress: Float
    @Binding var onboardingGradient: LinearGradient
    
    @State private var showText = false
    @State private var navigationDragHeight = 0.0
    
    var body: some View {
        ZStack {
            Color.base
            
            splashContent
        }
        .gesture(splashDragGesture)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 2)) {
                    onboardingProgress = 0.25
                    onboardingGradient = LinearGradient(colors: [.greenStart, .greenEnd], startPoint: .leading, endPoint: .trailing)
                }
            }
        }
    }
    
    private var splashContent: some View {
        VStack {
            Spacer()
            if showText {
                splashTextView
            }
            Spacer()
        }
        .padding(.bottom, 30)
        .blur(radius: effectiveBlurRadius())
        .transition(.opacity)
        .onAppear(perform: animateTextAppearance)
    }
    
    private var splashTextView: some View {
        VStack(spacing: 0) {
            Spacer()
            Text("Hello")
                .bold()
                .font(.system(size: 80))
                .foregroundStyle(.fontGray)
                .id("SplashText")
            Spacer()
            
            instructionText
        }
    }
    
    private var instructionText: some View {
        VStack {
            BouncingChevronView()
                .padding(.bottom, 5)
            
            Text("Swipe Upwards On The Canvas To Continue")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.fontGray)
                .id("InstructionText")
                .zIndex(1)
        }
    }
    
    private func animateTextAppearance() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut(duration: 2)) {
                showText = true
            }
        }
    }
    
    private func effectiveBlurRadius() -> CGFloat {
        abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.03) : 0
    }
    
    private var splashDragGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged { value in navigationDragHeight = value.translation.height }
            .onEnded { value in
                withAnimation(.easeInOut) {
                    handleDragEnd(navigationDragHeight: navigationDragHeight)
                    navigationDragHeight = 0.0
                }
            }
    }
    
    private func handleDragEnd(navigationDragHeight: CGFloat) {
        if navigationDragHeight < 50 {
            withAnimation(.easeInOut) {
                onboardingProgress = 0.5
                onboardingGradient = LinearGradient(colors: [.greenStart, .blueEnd], startPoint: .leading, endPoint: .trailing)
                appState = "healthPermission"
            }
        }
    }
}

#Preview {
    SplashView(onboardingProgress: .constant(0.25), onboardingGradient: .constant(LinearGradient(colors: [.greenStart, .greenEnd], startPoint: .leading, endPoint: .trailing)))
}
