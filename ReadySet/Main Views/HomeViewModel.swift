//
//  HomeViewModel.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/11/24.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @AppStorage("lastUseDate") var lastUseDate: String = ""

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
    
    func needRefreshFromDate() -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        
        if let dateOnly = calendar.date(from: dateComponents) {
            if dateOnly.description != lastUseDate {
                lastUseDate = dateOnly.description
                return true
            } else {
                return false
            }
        } else {
            print("Failed to remove time from the current date")
            return false
        }
    }
}
