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
    
    @State private var dragHeight = 0.0
    
    var body: some View {
        VStack {
            HeaderView(selectedTab: $selectedTab)
            
            VStack {
                ZStack {
                    HStack {
                        NavColumnView(tabItems: $tabItems, selectedTab: $selectedTab)
                            .offset(y: abs(dragHeight) > 20.0 ?
                                    (dragHeight.isLess(than: 0.0) ? max(dragHeight * 0.01, -5.0) : min(dragHeight * 0.01, 5.0)) : 0)

                        Spacer()
                    }
                    
                    getTopContentView(tabType: selectedTab.type)
                        .blur(radius: abs(dragHeight) > 20.0 ? abs(dragHeight * 0.01) : 0)
                }
                .frame(height: 150)
                
                Spacer()

            }
            .background(Color("BaseColor"))
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged({ value in
                    dragHeight = value.translation.height
                    print(dragHeight)
                })
                .onEnded({ value in
                    withAnimation (.bouncy) {
                        if dragHeight < -100 {
                            selectedTab = selectedTab.bumpTab(up: false)
                        }
                        
                        if dragHeight > 100 {
                            selectedTab = selectedTab.bumpTab(up: true)
                        }
                        
                        tabItems = selectedTab.reorderTabs()
                        dragHeight = 0.0
                    }
                }))
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
