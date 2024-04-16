//
//  UserRegistrationView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/11/24.
//

import SwiftUI

struct UserRegistrationView: View {
    @AppStorage("appState") var appState: String = "splash"
    @AppStorage("userName") var username: String = ""
    @Binding var color: Color
    
    @State private var name = ""
    @State private var showText = false
    @State private var showTextField = false
    @State private var navigationDragHeight = 0.0
    
    var body: some View {
        ZStack {
            Color.base
            registrationContent
        }
        .gesture(dragGesture)
        .onAppear {
            username = ""  // Reset username on view appear
        }
    }
    
    private var registrationContent: some View {
        VStack {
            Spacer()
            textDisplay
            Spacer()
        }
        .padding(.bottom, 15)
        .blur(radius: effectiveBlurRadius())
        .transition(.opacity)
    }
    
    private var textDisplay: some View {
        VStack(spacing: 0) {
            if showText {
                welcomeText
                    .padding(.bottom, 40)
            }
            
            if showTextField {
                VStack(spacing: 3) {
                    Text("Who are you?")
                        .font(.title3)
                        .foregroundStyle(.fontGray)
                        .id("QueryText")
                        .padding(.top)
                    
                    TextField("First Name", text: $name)
                        .textFieldStyle(OutlinedTextFieldStyle())
                        .padding(.horizontal, 30)
                        .autocorrectionDisabled()
                    
                    instructionsText
                }
            }
        }
        .onAppear(perform: animateTextAppearance)
    }
    
    private var welcomeText: some View {
        Text("Welcome To Ready, Set")
            .font(.title)
            .foregroundStyle(.fontGray)
            .id("WelcomeText")
            .padding(.bottom, showTextField ? 0 : 50)  // Adjust padding based on textField visibility
    }
    
    private var instructionsText: some View {
        Text(name.count > 1 ? "Swipe Upwards\nOn The Canvas When Finished" : " ")
            .frame(height: 100)
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundStyle(.fontGray)
            .animation(.easeInOut(duration: 2), value: name)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    private func animateTextAppearance() {
        withAnimation(.easeInOut(duration: 1.2)) {
            showText = true
        }
        withAnimation(.easeInOut(duration: 2).delay(0.5)) {
            showTextField = true
        }
    }
    
    private func effectiveBlurRadius() -> CGFloat {
        abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.01) : 0
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged { value in
                navigationDragHeight = value.translation.height
            }
            .onEnded { value in
                withAnimation(.smooth) {
                    if name.count > 1 {
                        handleDragEnd(navigationDragHeight: value.translation.height)
                    }
                    navigationDragHeight = 0
                }
            }
    }
    
    func handleDragEnd(navigationDragHeight: CGFloat) {
        if navigationDragHeight < 50 {
            withAnimation(.easeInOut) {
                color = .greenStart
                username = name
                appState = "goalSetting"
            }
        }
    }
}


#Preview {
    UserRegistrationView(color: .constant(.greenStart))
}