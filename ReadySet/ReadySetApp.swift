//
//  ReadySetApp.swift
//  ReadySet
//
//  Created by Nicholas Molargik on 4/10/24.
//

import SwiftUI
import SwiftData

@main
struct ReadySetApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: Exercise.self)
    }
}

