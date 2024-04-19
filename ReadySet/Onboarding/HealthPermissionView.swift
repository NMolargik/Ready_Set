//
//  HealthPermissionView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/11/24.
//

import SwiftUI
import HealthKit

struct HealthPermissionView: View {
    @AppStorage("appState") var appState: String = "splash"
    @Binding var onboardingProgress: Float
    @Binding var onboardingGradient: LinearGradient
    @Binding var healthController: HealthBaseController
    
    @State private var permitted = false
    @State private var showText = false
    @State private var showProgress = false
    @State private var showMoreText = false
    @State private var navigationDragHeight = 0.0
    
    var body: some View {
        ZStack {
            Color.base
            
            VStack {
                Spacer()
                
                if showText {
                    Text("Welcome To Ready, Set")
                        .bold()
                        .font(.system(size: 50))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.fontGray)
                        .id("WelcomeText")
                        .padding(.bottom, permitted ? 0 : 30)
                }
                
                if showMoreText {
                    Text("Aside from other features, we use Apple Health to store and track your trends in water and energy consumption. Please hit the button below, and select 'Turn On All' on the following prompt")
                        .multilineTextAlignment(.center)
                        .padding()
                        .font(.title3)
                        .foregroundStyle(.fontGray)
                }
                
                if showProgress {
                    ProgressView()
                        .tint(.blue)
                        .frame(height: 50)
                        .padding()
                    
                } else if permitted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.green)
                    
                } else if showMoreText {
                    Button(action: {
                        showProgress = true
                        healthController.requestAuthorization()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                showProgress = false
                                permitted = true
                            }
                        }
                    }, label: {
                        ZStack {
                            Rectangle()
                                .foregroundStyle(.fontGray)
                                .cornerRadius(10)
                                .frame(width: 250, height: 50)
                                .padding()
                                .shadow(radius: 10)
                            
                            HStack {
                                Text("Authorize Health")
                                    .foregroundStyle(.baseInvert)
                                
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.pink)
                            }
                            .font(.title2)
                            .bold()
                            .padding()
                            
                        }
                    })
                }
                
                Spacer()
                    
                if (permitted) {
                    Text("Swipe Upwards On The Canvas To Continue")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.fontGray)
                        .id("InstructionText")
                        .zIndex(1)
                }
            }
            .onAppear(perform: animateTextAppearance)
            
            .blur(radius: effectiveBlurRadius())
            .transition(.opacity)
            .padding(.bottom, 30)
        }
        .gesture(dragGesture)

    }
    
    private func animateTextAppearance() {
        withAnimation(.easeInOut(duration: 1.2)) {
            showText = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut(duration: 1.2)) {
                showMoreText = true
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
                    if permitted {
                        handleDragEnd(navigationDragHeight: value.translation.height)
                    }
                    navigationDragHeight = 0
                }
            }
    }
    
    func handleDragEnd(navigationDragHeight: CGFloat) {
        healthController.requestAuthorization()
        if navigationDragHeight < 50 {
            withAnimation(.easeInOut) {
                onboardingProgress = 0.75
                onboardingGradient = LinearGradient(colors: [.greenStart, .blueEnd, .orangeStart], startPoint: .leading, endPoint: .trailing)
                appState = "goalSetting"
            }
        }
    }
}


#Preview {
    HealthPermissionView(onboardingProgress: .constant(0.5), onboardingGradient: .constant(LinearGradient(colors: [.greenStart, .blueEnd], startPoint: .leading, endPoint: .trailing)), healthController: .constant(HealthBaseController()))
}
