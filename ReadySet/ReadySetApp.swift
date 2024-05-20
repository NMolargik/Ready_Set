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
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(for: Exercise.self)
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .background:
                addQuickActions()
            case .inactive:
                break
            case .active:
                break
            @unknown default:
                break
            }
        }
    }

    func addQuickActions() {
        UIApplication.shared.shortcutItems = [
            UIApplicationShortcutItem(type: "Exercise", localizedTitle: "Exercise", localizedSubtitle: "", icon: UIApplicationShortcutIcon(systemImageName: "dumbbell")),

            UIApplicationShortcutItem(type: "Water", localizedTitle: "Water", localizedSubtitle: "", icon: UIApplicationShortcutIcon(systemImageName: "drop")),

            UIApplicationShortcutItem(type: "Energy", localizedTitle: "Energy", localizedSubtitle: "", icon: UIApplicationShortcutIcon(systemImageName: "flame"))
        ]
    }
}
