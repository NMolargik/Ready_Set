//
//  HomeView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct HomeView: View {
    @State var selectedTab: any ITabItem = ExerciseTabItem()
    @State var tabItems = TabItemType.allItems
    
    @State private var navigationDragHeight = 0.0
    @State private var topDragHeight = 0.0
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    HStack {
                        NavColumnView(tabItems: $tabItems, selectedTab: $selectedTab)
                            .offset(y: abs(navigationDragHeight) > 20.0 ?
                                    (navigationDragHeight.isLess(than: 0.0) ? max(navigationDragHeight * 0.01, -5.0) : min(navigationDragHeight * 0.01, 5.0)) : 0)

                        Spacer()
                    }
                    
                    getTopContentView(tabType: selectedTab.type)
                        .blur(radius: abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.01) : 0)
                }
                .frame(height: 150)
                .offset(y: 90)
                
                Spacer()

            }
            .background(Color("BaseColor"))
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged({ value in
                    navigationDragHeight = value.translation.height
                })
                .onEnded({ value in
                    withAnimation (.bouncy) {
                        if navigationDragHeight < -100 {
                            selectedTab = selectedTab.bumpTab(up: false)
                        }
                        
                        if navigationDragHeight > 100 {
                            selectedTab = selectedTab.bumpTab(up: true)
                        }
                        
                        tabItems = selectedTab.reorderTabs()
                        navigationDragHeight = 0.0
                    }
                }))
            
            VStack {
                HeaderView(selectedTab: $selectedTab)
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ value in
                            topDragHeight = value.translation.height
                        })
                            .onEnded({ value in
                                topDragHeight = 0.0
                            }))
                    .frame(height: 90 + topDragHeight)
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func getTopContentView(tabType: TabItemType) -> some View {
        switch (tabType) {
        case .exercise:
            ExerciseTopContentView()
        case .metrics:
            MetricTopContentView()
        case .water:
            WaterTopContentView()
        case .calorie:
            CalorieTopContentView()
        }
    }
}



#Preview {
    HomeView()
        .ignoresSafeArea()
}
