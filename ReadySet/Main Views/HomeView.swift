//
//  HomeView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var homeViewModel = HomeViewModel()
    
    @State var showGestureModal = false
    @State private var navigationDragHeight = 0.0
    @State private var navigationDragWidth = 0.0
    @State private var topDragHeight = 0.0
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                HeaderView(selectedTab: $homeViewModel.selectedTab)
                    .padding(.bottom, 15)
                
                NavColumnView(tabItems: $homeViewModel.tabItems, selectedTab: $homeViewModel.selectedTab, navigationDragHeight: $navigationDragHeight, showBottomSheet: $homeViewModel.showBottomSheet)
                
                BottomView(selectedTab: $homeViewModel.selectedTab)
                    .blur(radius: abs(navigationDragHeight) > 10.0 && abs(navigationDragWidth) < 50 ? abs(navigationDragHeight * 0.05) : 0)
                
                GestureBarView(homeViewModel: homeViewModel, showGestureModal: $showGestureModal)
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ value in
                            navigationDragHeight = value.translation.height
                            navigationDragWidth = value.translation.width
                            
                            homeViewModel.handleDragUpdate(navigationDragWidth: navigationDragWidth, navigationDragHeight: navigationDragHeight)
                            
                        })
                            .onEnded({ value in
                                withAnimation (.smooth) {
                                    homeViewModel.handleDragEnd(navigationDragWidth: navigationDragWidth, navigationDragHeight: navigationDragHeight)
                                    
                                    navigationDragHeight = 0.0
                                    navigationDragWidth = 0.0
                                }
                            }))
                    .defersSystemGestures(on: .bottom)
                    .offset(x: navigationDragWidth * 0.01, y: navigationDragHeight * 0.02)
                    .shadow(radius: 3, x: navigationDragWidth * 0.02, y: navigationDragHeight * -0.02)
                
            }
            .background(LinearGradient(colors: [Color("BaseColor"), Color("BaseColor"), Color("BaseColor"), Color("BaseColor"), Color("BaseColor"),  homeViewModel.selectedTab.color], startPoint: .top, endPoint: .bottom))
            .sheet(isPresented: $homeViewModel.showBottomSheet) {
                VStack {
                    switch (homeViewModel.selectedTab.type) {
                    case .exercise:
                        Text("Exercise Sheet")
                    case .water:
                        Text("Water Sheet")
                    case .calorie:
                        Text("Calorie Sheet")
                    case .settings:
                        Text("Settings Sheet")
                    }
                }
                .presentationDetents([homeViewModel.selectedTab.sheetPresentationDetent])
            }
            
            if (homeViewModel.showGestureModal) {
                GestureModalView(selectedTab: homeViewModel.selectedTab, navigationDragWidth: $navigationDragWidth)
                    .transition(.scale)
            }
        }
    }
}

#Preview {
    HomeView()
        .ignoresSafeArea()
}
