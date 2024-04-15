//
//  NavigationTutorialView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI

struct NavigationTutorialView: View {
    @AppStorage("appState") var appState: String = "goalSetting"
    @AppStorage("userName") var username: String = ""
    @Binding var color: Color
    
    @State private var showText = false
    @State private var showMoreText = false
    @State private var navigationDragHeight = 0.0
    
    let tabItems = TabItemType.allItems
    
    var body: some View {
        ZStack {
            Color.base
            
            VStack {
                Spacer()
                
                HStack {
                    if (showText) {
                        VStack (alignment: .leading) {
                            ForEach(tabItems, id: \.type) { tabItem in
                                Image(tabItem.icon)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(tabItem.color)
                                    .transition(.opacity)
                            }
                        }
                        .padding(.leading, 5)
                        .frame(height: 120)
                    
                        Spacer()
                        
                        Text("You can navigate Ready, Set by swiping vertically, just as you have been!\n\nOr by tapping any of these icons wherever they appear.")
                            .multilineTextAlignment(.leading)
                            .font(.body)
                            .foregroundStyle(.fontGray)
                            .padding(.trailing)
                    }
                    
                }
                .padding(.top, 50)
                .padding(.horizontal, 8)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation (.easeInOut(duration: 2)) {
                            showText = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation (.easeInOut(duration: 2)) {
                                showMoreText = true
                            }
                        }
                    }
                }
                .transition(.opacity)
                
                Spacer()
                
                if (showMoreText) {
                    Text("If you did not enter them previously, we recommend filling our your sets on the Exercise page for the full experience.")
                        .multilineTextAlignment(.center)
                        .font(.body)
                        .foregroundStyle(.fontGray)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    BouncingChevronView()
                        .padding(.bottom, 15)
                    
                    Text("Swipe Upwards\nTo Enter Ready, Set")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.fontGray)
                        .id("SplashText")
                        .zIndex(1)
                }
            }
            .padding(.bottom, 15)
            .blur(radius: abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.01) : 0)
        }
        
        .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged({ value in
                navigationDragHeight = value.translation.height
            })
            .onEnded({ value in
                if (showMoreText) {
                    withAnimation (.smooth) {
                        handleDragEnd(navigationDragHeight: navigationDragHeight)
                    }
                }
                
                withAnimation {
                    navigationDragHeight = 0.0
                }
            })
        )
    }
    
    func handleDragEnd(navigationDragHeight: CGFloat) {
        print(navigationDragHeight)
        if navigationDragHeight < 50 {
            withAnimation (.easeInOut) {
                color = .clear
                appState = "running"
            }
        }
    }
}

#Preview {
    NavigationTutorialView(color: .constant(.clear))
}
