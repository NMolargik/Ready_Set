//
//  HomeViewModel.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/11/24.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var selectedTab: any ITabItem = ExerciseTabItem()
    @Published var tabItems = TabItemType.allItems
    @Published var topDrawerOpen = false
    @Published var showBottomSheet = false
    @Published var showGestureModal = false
    
    func handleDragUpdate(navigationDragWidth: CGFloat, navigationDragHeight: CGFloat) {
        print(navigationDragWidth)
        if abs(navigationDragHeight) < 50 && navigationDragWidth > 50 && !showGestureModal {
            withAnimation {
                if ([TabItemType.calorie, TabItemType.water].contains(selectedTab.type)) {
                    showGestureModal = true
                    self.evaluateModal(navigationDragWidth: navigationDragWidth)
                }
                
            }
        } else if abs(navigationDragHeight) < 20 && navigationDragWidth < -50 && !showGestureModal{
            withAnimation {
                if ([TabItemType.calorie, TabItemType.water].contains(selectedTab.type)) {
                    showGestureModal = true
                    self.evaluateModal(navigationDragWidth: navigationDragWidth)
                }
            }
        }
    }
    
    func handleDragEnd(navigationDragWidth: CGFloat, navigationDragHeight: CGFloat) {
        if navigationDragHeight < -100 && abs(navigationDragWidth) < 200 {
            self.selectedTab = self.selectedTab.bumpTab(up: false)
            self.tabItems = self.selectedTab.reorderTabs()
        }
        
        if navigationDragHeight > 50 && abs(navigationDragWidth) < 200 {
            self.selectedTab = self.selectedTab.bumpTab(up: true)
            self.tabItems = self.selectedTab.reorderTabs()
        }
        
        withAnimation {
            showGestureModal = false
        }
    }
    
    func evaluateModal(navigationDragWidth: CGFloat) {
        
    }
}
