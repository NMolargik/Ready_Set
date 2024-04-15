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
            
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    if (showText) {
                        Spacer()
                        
                        Text("Hello")
                            .font(.largeTitle)
                            .foregroundStyle(.fontGray)
                            .id("SplashText")
                        
                        Spacer()
                        
                        BouncingChevronView()
                            .padding(.bottom, 15)
                        
                        Text("Swipe Upwards\nOn The Canvas To Continue")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.fontGray)
                            .id("SplashText")
                            .zIndex(1)
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation (.easeInOut(duration: 2)) {
                            showText = true
                        }
                    }
                }
                .transition(.opacity)
                
                Spacer()
            }
            .padding(.bottom, 15)
            .blur(radius: abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.01) : 0)
        }
        
        .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged({ value in
                navigationDragHeight = value.translation.height
            })
            .onEnded({ value in
                withAnimation (.smooth) {
                    handleDragEnd(navigationDragHeight: navigationDragHeight)
                    navigationDragHeight = 0.0
                }
            })
        )
        .onAppear {
            withAnimation {
                color = .purpleStart
            }
        }
    }
    
    func handleDragEnd(navigationDragHeight: CGFloat) {
        print(navigationDragHeight)
        if navigationDragHeight < 50 {
            withAnimation (.easeInOut) {
                color = .orangeStart
                appState = "register"
            }
        }
    }
}

#Preview {
    SplashView(color: .constant(.purpleStart))
}
