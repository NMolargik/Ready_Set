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
    
    func handleDragEnd(navigationDragHeight: CGFloat) {
        if navigationDragHeight < -100 {
            self.selectedTab = self.selectedTab.bumpTab(up: false)
            self.tabItems = self.selectedTab.reorderTabs()
        }
        
        if navigationDragHeight > 50 {
            self.selectedTab = self.selectedTab.bumpTab(up: true)
            self.tabItems = self.selectedTab.reorderTabs()
        }
    }
}
