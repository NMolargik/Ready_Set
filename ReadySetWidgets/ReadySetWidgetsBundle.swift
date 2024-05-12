//
//  ReadySetWidgetsBundle.swift
//  ReadySetWidgets
//
//  Created by Nick Molargik on 4/28/24.
//

import WidgetKit
import SwiftUI

@main
struct ReadySetWidgetsBundle: WidgetBundle {
    var body: some Widget {
        ReadySetWaterWidget()

        ReadySetEnergyWidget()
    }
}
