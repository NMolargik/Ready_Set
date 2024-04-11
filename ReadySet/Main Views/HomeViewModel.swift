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
}
