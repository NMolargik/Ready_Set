//
//  HomeViewModel.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/11/24.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @AppStorage("lastUseDate") var lastUseDate: String = "2024-04-19"

    @Published var selectedTab: any ITabItem = ExerciseTabItem()
    @Published var tabItems = TabItemType.allItems
    
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let dateOnly = calendar.date(from: dateComponents) {
            let formattedDate = dateFormatter.string(from: dateOnly)
            print("Last Date: \(lastUseDate) | Current Date: \(formattedDate)")
            if formattedDate != lastUseDate {
                lastUseDate = formattedDate
                return true
            }
        } else {
            print("Failed to remove time from the current date")
        }
        return false
    }
}




