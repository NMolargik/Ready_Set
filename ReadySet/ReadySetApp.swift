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


extension Bundle {
    var projectVersion: String {
        return self.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }
    
    var bundleVersion: String {
        return self.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
}
