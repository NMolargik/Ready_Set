//
//  GoalSetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI


    //TODO: fix this page!
struct GoalSetView: View {
    @AppStorage("appState") var appState: String = "goalSetting"
    @Binding var color: Color
    
    @State private var showText = false
    @State private var showMoreText = false
    @State private var navigationDragHeight = 0.0
    
    var body: some View {
        ZStack {
            Color.base
            VStack {
                if showText {
                    Spacer()
                    Text("Time to fill out your exercise sets. You should only have to do this once, and you can move forward empty if you want.")
                        .multilineTextAlignment(.center)
                        .font(.body)
                        .foregroundStyle(.fontGray)
                        .padding(.horizontal)
                        .transition(.opacity)
                }
                
                Spacer()
                Text("Swipe Upwards\nOn The Canvas When Finished")
                    .frame(height: 100)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.fontGray)
                    .animation(.easeInOut(duration: 2))
                    .transition(.move(edge: .bottom).combined(with: .opacity))

            }
            .blur(radius: blurRadiusForDrag())
            .padding(.bottom, 15)
        }
        .gesture(dragGesture)
        .onAppear(perform: animateText)
    }

    private func animateText() {
        withAnimation(.easeInOut(duration: 2)) {
            showText = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                withAnimation {
                    showMoreText = true
                }
            }
        }
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged { value in navigationDragHeight = value.translation.height }
            .onEnded { value in
                withAnimation(.smooth) {
                    handleDragEnd(navigationDragHeight: value.translation.height)
                    navigationDragHeight = 0.0
                }
            }
    }
    
    private func blurRadiusForDrag() -> CGFloat {
        abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.03) : 0
    }
    
    private func handleDragEnd(navigationDragHeight: CGFloat) {
        if navigationDragHeight < 50 {
            withAnimation(.easeInOut) {
                color = .blueEnd
                appState = "navigationTutorial"
            }
        }
    }
}

#Preview {
    GoalSetView(color: .constant(.blueStart))
}
