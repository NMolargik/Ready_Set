//
//  ITabItem.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

protocol ITabItem: Hashable, Equatable {
    var text: String { get }
    var type: TabItemType { get }
    var icon: String { get }
    var color: Color { get }
    var secondaryColor: Color { get }
    var gradient: LinearGradient { get }

    func bumpTab(up: Bool) -> any ITabItem
    func reorderTabs() -> [any ITabItem]
}

extension ITabItem {
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.type == rhs.type
    }
}
