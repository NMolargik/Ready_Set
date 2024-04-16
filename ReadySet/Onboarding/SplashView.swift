//
//  SplashView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI

struct SplashView: View {
    @AppStorage("appState") var appState: String = "splash"
    @Binding var color: Color
    
    @State private var showText = false
    @State private var navigationDragHeight = 0.0
    
    var body: some View {
        ZStack {
            Color.base
            splashContent
        }
        .gesture(splashDragGesture)
        .onAppear {
            animateInitialColorChange()
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
        .padding(.bottom, 15)
        .blur(radius: effectiveBlurRadius())
        .transition(.opacity)
        .onAppear(perform: animateTextAppearance)
    }
    
    private var splashTextView: some View {
        VStack(spacing: 0) {
            Spacer()
            Text("Hello")
                .font(.largeTitle)
                .foregroundStyle(.fontGray)
                .id("SplashText")
            Spacer()
            BouncingChevronView().padding(.bottom, 15)
            instructionText
        }
    }
    
    private var instructionText: some View {
        Text("Swipe Upwards\nOn The Canvas To Continue")
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundStyle(.fontGray)
            .id("InstructionText")
            .zIndex(1)
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
                withAnimation(.smooth) {
                    handleDragEnd(navigationDragHeight: navigationDragHeight)
                    navigationDragHeight = 0.0
                }
            }
    }
    
    private func handleDragEnd(navigationDragHeight: CGFloat) {
        if navigationDragHeight < 50 {
            withAnimation(.easeInOut) {
                color = .orangeStart
                appState = "register"
            }
        }
    }
    
    private func animateInitialColorChange() {
        withAnimation {
            color = .purpleStart
        }
    }
}

#Preview {
    SplashView(color: .constant(.purpleStart))
}
