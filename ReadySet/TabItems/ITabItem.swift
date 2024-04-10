//
//  ITabItem.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import Foundation
import SwiftUI

protocol ITabItem: Hashable, Equatable {
    var text: String { get }
    var selectedIconName: String { get }
    var unselectedIconName: String { get }
    var color: Color { get }
}

extension ITabItem {
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.text == rhs.text
    }
}
