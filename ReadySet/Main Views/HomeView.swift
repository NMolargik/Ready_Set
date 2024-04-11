//
//  HomeView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var homeViewModel = HomeViewModel()
    
    @State private var navigationDragHeight = 0.0
    @State private var topDragHeight = 0.0
    
    var body: some View {
        VStack {
            HeaderView(selectedTab: $homeViewModel.selectedTab)
                .padding(.bottom, 15)
            
            NavColumnView(tabItems: $homeViewModel.tabItems, selectedTab: $homeViewModel.selectedTab, navigationDragHeight: $navigationDragHeight, showBottomSheet: $homeViewModel.showBottomSheet)
            
            BottomView(selectedTab: $homeViewModel.selectedTab)
                .blur(radius: abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.01) : 0)
            
            Spacer()
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
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({ value in
                navigationDragHeight = value.translation.height
            })
            .onEnded({ value in
                withAnimation (.bouncy) {
                    if navigationDragHeight < -100 {
                        homeViewModel.selectedTab = homeViewModel.selectedTab.bumpTab(up: false)
                    }
                    
                    if navigationDragHeight > 100 {
                        homeViewModel.selectedTab = homeViewModel.selectedTab.bumpTab(up: true)
                    }
                    
                    homeViewModel.tabItems = homeViewModel.selectedTab.reorderTabs()
                    navigationDragHeight = 0.0
                }
            }))
    }
}

#Preview {
    HomeView()
        .ignoresSafeArea()
}
