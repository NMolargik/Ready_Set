//
//  SceneDelegate.swift
//  ReadySet
//
//  Created by Nick Molargik on 5/20/24.
//

import Foundation
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let homeViewModel: HomeViewModel = .shared
        homeViewModel.handleShortcutItem(shortcutItem)
    }
}
