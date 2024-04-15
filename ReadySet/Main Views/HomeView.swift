//
//  HomeView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var homeViewModel = HomeViewModel()
    
    @StateObject var waterViewModel = WaterViewModel()
    @StateObject var calorieViewModel = CalorieViewModel()

    @State private var navigationDragHeight = 0.0
    
    var body: some View {
        VStack {
            HeaderView(selectedTab: $homeViewModel.selectedTab)
                .padding(.bottom, 15)
            
            NavColumnView(waterViewModel: waterViewModel, calorieViewModel: calorieViewModel, tabItems: $homeViewModel.tabItems, selectedTab: $homeViewModel.selectedTab, navigationDragHeight: $navigationDragHeight)
            
            BottomView(waterViewModel: waterViewModel, calorieViewModel: calorieViewModel, selectedTab: $homeViewModel.selectedTab)
                .blur(radius: abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.01) : 0)
                .padding(.bottom, 15)
        }
        .background(LinearGradient(colors: [Color("BaseColor"), Color("BaseColor"), Color("BaseColor"), Color("BaseColor"), Color("BaseColor"),  homeViewModel.selectedTab.color], startPoint: .top, endPoint: .bottom))
        .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged({ value in
                navigationDragHeight = value.translation.height
            })
            .onEnded({ value in
                withAnimation (.smooth) {
                    homeViewModel.handleDragEnd(navigationDragHeight: navigationDragHeight)
                    navigationDragHeight = 0.0
                }
            })
        )
    }
}

#Preview {
    HomeView()
        .ignoresSafeArea()
}
