//
//  OnboardingView.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import SwiftUI
import HealthKit

struct OnboardingView: View {
    @AppStorage("watchOnboardingComplete", store: UserDefaults(suiteName: Bundle.main.groupID)) var watchOnboardingComplete = false

    @Binding var appState: String

    @State private var showText = false
    @State private var swiped = false
    @State private var navigationDragHeight = 0.0

    var body: some View {
        ZStack {
            VStack {
                Text("Hello")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .id("SplashText")

                if showText {
                    HStack {
                        Image(systemName: "iphone.gen3")
                            .font(.largeTitle)

                        Text("Searching for Ready, Set...")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .id("InstructionText")
                            .lineLimit(4)
                            .animation(.easeInOut, value: showText)
                            .frame(height: 100)
                    }
                    .foregroundStyle(.white)

                    ProgressView()
                        .tint(.white)
                        .controlSize(.large)
                        .padding(.bottom)
                }
            }
        }
        .blur(radius: effectiveBlurRadius())
        .gesture(dragGesture)
        .onAppear {
            animateTextAppearance()
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
