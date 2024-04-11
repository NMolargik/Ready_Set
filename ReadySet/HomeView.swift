//
//  HomeView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct HomeView: View {
    @State private var navigationDragHeight = 0.0
    @State private var topDragHeight = 0.0
    
    @State var selectedTab: any ITabItem = ExerciseTabItem()
    @State var tabItems = TabItemType.allItems
    @State var topDrawerOpen = false
    
    var body: some View {
        VStack {
            HeaderView(selectedTab: $selectedTab)
                .padding(.bottom, 5)
            
            NavColumnView(tabItems: $tabItems, selectedTab: $selectedTab, navigationDragHeight: $navigationDragHeight)
            
            BottomView(selectedTab: $selectedTab)
                .blur(radius: abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.01) : 0)
            
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
    }
}



#Preview {
    HomeView()
        .ignoresSafeArea()
}
