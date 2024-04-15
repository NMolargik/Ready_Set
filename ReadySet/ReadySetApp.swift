//
//  ReadySetApp.swift
//  ReadySet
//
//  Created by Nicholas Molargik on 4/10/24.
//

import SwiftUI

@main
struct ReadySetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
