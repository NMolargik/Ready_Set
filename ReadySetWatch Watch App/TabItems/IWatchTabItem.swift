//
//  IWatchTabItem.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import Foundation
import SwiftUI

protocol IWatchTabItem: Hashable, Equatable {
    var text: String { get }
    var type: WatchTabItemType { get }
    var icon: String { get }
    var color: Color { get }
    var secondaryColor: Color { get }
    var gradient: LinearGradient { get }
}

extension IWatchTabItem {
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.type == rhs.type
    }
}
