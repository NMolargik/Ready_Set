//
//  GoalSetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI

struct GoalSetView: View {
    @AppStorage("appState") var appState: String = "goalSetting"
    @AppStorage("userName") var username: String = ""
    @Binding var color: Color
    
    @State private var showText = false
    @State private var showMoreText = false
    @State private var navigationDragHeight = 0.0
    
    var body: some View {
        ZStack {
            Color.base
            
            VStack {
                VStack(spacing: 0) {
                    if (showText) {
                        Text("Hi, \(username)")
                            .font(.title)
                            .foregroundStyle(.fontGray)
                            .id("SplashText")
                            .padding(.top, 80)
                    }
                    
                    if (showMoreText) {
                        Text("Time to fill out your exercise sets. You should only have to do this once, and you can move forward empty if you want.")
                            .multilineTextAlignment(.center)
                            .font(.body)
                            .foregroundStyle(.fontGray)
                            .padding(.horizontal)
                    }
                        
                    Spacer()
                    
                    Text(username.count > 1 ? "Swipe Upwards\nOn The Canvas When Finished" : " ")
                        .frame(height: 100)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.fontGray)
                        .animation(.easeInOut(duration: 2), value: username)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation (.easeInOut(duration: 2)) {
                            showText = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                            withAnimation (.easeInOut(duration: 2)) {
                                showMoreText = true
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
                if (username.count > 1) {
                    withAnimation (.smooth) {
                        handleDragEnd(navigationDragHeight: navigationDragHeight)
                        navigationDragHeight = 0.0
                    }
                }
            })
        )
    }
    
    func handleDragEnd(navigationDragHeight: CGFloat) {
        print(navigationDragHeight)
        if navigationDragHeight < 50 {
            withAnimation (.easeInOut) {
                color = .blueEnd
                appState = "navigationTutorial"
            }
        }
    }
}

#Preview {
    GoalSetView(color: .constant(.blueStart))
}
