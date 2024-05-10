//
//  AppDelegate.swift
//  ReadySet
//
//  Created by Nick Molargik on 5/9/24.
//

import Foundation
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        observeWaterAddNotification()
        observeEnergyConsumeNotification()
        return true
    }
    
    func observeWaterAddNotification() {
        let notificationName = "com.nickmolargik.addWaterNotification"
        print("Registering observer for \(notificationName)")
        if let center = CFNotificationCenterGetDarwinNotifyCenter() {
            CFNotificationCenterAddObserver(center, nil, { (center, observer, name, object, userInfo) in
                DispatchQueue.main.async {
                    print("Notification received for water")
                    WaterViewModel.shared.addSomeWater()
                }
            }, notificationName as CFString, nil, .deliverImmediately)
        }
    }
    
    func observeEnergyConsumeNotification() {
        let notificationName = "com.nickmolargik.consumeEnergyNotification"
        if let center = CFNotificationCenterGetDarwinNotifyCenter() {
            CFNotificationCenterAddObserver(center, nil, { (center, observer, name, object, userInfo) in
                DispatchQueue.main.async {
                    print("Notification received for energy")
                    EnergyViewModel.shared.consumeSomeEnergy()
                }
            }, notificationName as CFString, nil, .deliverImmediately)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        let waterNotificationName = "com.nickmolargik.addWaterNotification"
        let energyNotificationName = "com.nickmolargik.consumeEnergyNotification"
        if let center = CFNotificationCenterGetDarwinNotifyCenter() {
            CFNotificationCenterRemoveObserver(center, nil, CFNotificationName(waterNotificationName as CFString), nil)
            CFNotificationCenterRemoveObserver(center, nil, CFNotificationName(energyNotificationName as CFString), nil)
        }
    }
}
