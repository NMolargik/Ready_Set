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
            
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    if (showText) {
                        Spacer()
                        
                        Text("Welcome To Ready, Set")
                            .font(.title)
                            .foregroundStyle(.fontGray)
                            .id("SplashText")
                    }
                    
                    if (showTextField) {
                        
                        Text("Who are you?")
                            .font(.title3)
                            .foregroundStyle(.fontGray)
                            .id("SplashText")
                            .padding(.top)
                            .padding(.bottom, 3)
                        
                        TextField("First Name", text: $name)
                            .textFieldStyle(OutlinedTextFieldStyle())
                            .padding(.horizontal, 30)
                    }
                        
                    Spacer()
                    
                    Text(name.count > 1 ? "Swipe Upwards\nOn The Canvas When Finished" : " ")
                        .frame(height: 100)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.fontGray)
                        .animation(.easeInOut(duration: 2), value: name)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation (.easeInOut(duration: 1.2)) {
                            showText = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation (.easeInOut(duration: 2)) {
                                showTextField = true
                            }
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
                    if (name.count > 1) {
                        handleDragEnd(navigationDragHeight: navigationDragHeight)
                    }
                    
                    navigationDragHeight = 0
                }
            })
        )
        .onAppear {
            username = ""
        }
    }
    
    func handleDragEnd(navigationDragHeight: CGFloat) {
        print(navigationDragHeight)
        if navigationDragHeight < 50 {
            withAnimation (.easeInOut) {
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
