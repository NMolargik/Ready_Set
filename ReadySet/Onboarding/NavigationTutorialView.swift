//
//  NavigationTutorialView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI

struct NavigationTutorialView: View {
    @AppStorage("appState") var appState: String = "goalSetting"
    @Binding var onboardingProgress: Float
    @Binding var onboardingGradient: LinearGradient
    
    @State private var showText = false
    @State private var showMoreText = false
    @State private var navigationDragHeight = 0.0
    
    let tabItems = TabItemType.allItems

    var body: some View {
        ZStack {
            Color.base
            VStack(spacing: 15) {
                Spacer()

                if showText {
                    HStack {
                        iconStack
                        navText
                    }     .transition(.opacity)
                    
                }
                
                Spacer()
           
                
                if showMoreText {
                    moreInstructions
                    
                    Spacer()
                    
                    instructionText
                }
            }
            .padding(.bottom, 30)
            .onAppear(perform: animateText)
            .blur(radius: blurRadiusForDrag())
        }
        .gesture(dragGesture)
    }
    
    private var iconStack: some View {
        VStack(alignment: .leading) {
            ForEach(tabItems, id: \.type) { tabItem in
                Image(tabItem.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(tabItem.color)
            }
        }
        .frame(height: 120)
        .padding(.leading, 5)
    }
    
    private var navText: some View {
        Text("You can navigate Ready, Set by swiping vertically, just as you have been...\n\nOr by tapping any of these icons wherever they appear.")
            .multilineTextAlignment(.leading)
            .font(.body)
            .foregroundStyle(.fontGray)
            .padding(.trailing)
    }
    
    private var moreInstructions: some View {
        VStack {
            Text("If you did not enter them previously, we recommend filling out your sets on the Exercise page for the full experience.")
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundStyle(.fontGray)
                .padding(.horizontal)
                .padding(.bottom, 50)
        }
    }
    
    private var instructionText: some View {
        VStack {
            BouncingChevronView()
                .padding(.bottom, 5)
            
            Text("Swipe Upwards On The Canvas When Ready")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.fontGray)
                .id("InstructionText")
                .zIndex(1)
        }
        .padding(.bottom, 15)
    }
    
    private var finalSwipeInstruction: some View {
        Text("Swipe Upwards To Enter Ready, Set")
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundStyle(.fontGray)
            .id("FinalInstruction")
            .zIndex(1)
    }
    
    private func animateText() {
        withAnimation(.easeInOut(duration: 2)) {
            showText = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation(.easeInOut(duration: 1.5)) {
                    showMoreText = true
                }
            }
        }
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged { value in navigationDragHeight = value.translation.height }
            .onEnded { value in
                handleDrag(value: value)
            }
    }
    
    private func handleDrag(value: DragGesture.Value) {
        withAnimation (.easeInOut) {
            if showMoreText && value.translation.height < 50 {
                handleDragEnd(navigationDragHeight: value.translation.height)
            }
            navigationDragHeight = 0.0
        }
    }
    
    private func blurRadiusForDrag() -> CGFloat {
        abs(navigationDragHeight) > 20 ? abs(navigationDragHeight * 0.03) : 0
    }
    
    private func handleDragEnd(navigationDragHeight: CGFloat) {
        withAnimation(.easeInOut(duration: 2)) {
            appState = "running"
        }
    }
}

#Preview {
    NavigationTutorialView(onboardingProgress: .constant(1.2), onboardingGradient: .constant(LinearGradient(colors: [.greenStart, .blueEnd, .orangeStart, .purpleEnd], startPoint: .leading, endPoint: .trailing)))
}
