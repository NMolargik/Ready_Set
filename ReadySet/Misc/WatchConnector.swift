//
//  WatchConnector.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/25/24.
//

import Foundation
import WatchConnectivity
import SwiftUI

class WatchConnector: NSObject, WCSessionDelegate, ObservableObject {
    static var shared = WatchConnector()
    @AppStorage("appState", store: UserDefaults(suiteName: Bundle.main.groupID)) var appState: String = "background"
    @AppStorage("useMetric", store: UserDefaults(suiteName: Bundle.main.groupID)) var useMetric: Bool = false
    @AppStorage("stepGoal", store: UserDefaults(suiteName: Bundle.main.groupID)) var stepGoal: Double = 1000
    @AppStorage("stepsToday", store: UserDefaults(suiteName: Bundle.main.groupID)) var stepsToday: Int = 0
    @AppStorage("waterGoal", store: UserDefaults(suiteName: Bundle.main.groupID)) var waterGoal: Double = 64
    @AppStorage("waterConsumedToday", store: UserDefaults(suiteName: Bundle.main.groupID)) var waterConsumedToday: Int = 0
    @AppStorage("energyGoal", store: UserDefaults(suiteName: Bundle.main.groupID)) var energyGoal: Double = 2000
    @AppStorage("energyConsumedToday", store: UserDefaults(suiteName: Bundle.main.groupID)) var energyConsumedToday: Int = 0

    var addConsumption: ((EntryType, Int) -> Void)
    var session: WCSession

    init(session: WCSession = .default) {
        self.addConsumption = { _, _ in }
        self.session = session
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        } else {
            print("WCSession not supported on this device")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        var response: [String: Any] = ["complete": true]
        response["appState"] = self.appState

        if let _ = message["giveUseMetric"] as? Bool {
            response["useMetric"] = self.useMetric
        }

        if let _ = message["giveStepGoal"] as? Bool {
            response["stepGoal"] = self.stepGoal
        }

        if let _ = message["giveWaterGoal"] as? Bool {
            response["waterGoal"] = self.waterGoal
        }

        if let _ = message["giveEnergyGoal"] as? Bool {
            response["energyGoal"] = self.energyGoal
        }

        if let _ = message["giveStepBalance"] as? Bool {
            response["stepBalance"] = self.stepsToday
        }

        if let _ = message["giveWaterBalance"] as? Bool {
            response["waterBalance"] = self.waterConsumedToday
        }

        if let _ = message["giveEnergyBalance"] as? Bool {
            response["energyBalance"] = self.energyConsumedToday
        }

        if let waterIntake = message["newWaterIntake"] as? Int {
            let newBalance = self.waterConsumedToday + waterIntake
            receiveNewWaterIntakeFromWatch(intake: waterIntake)
            response["waterBalance"] = newBalance
        }

        if let energyIntake = message["newEnergyIntake"] as? Int {
            let newBalance = self.energyConsumedToday + energyIntake
            receiveNewEnergyIntakeFromWatch(intake: energyIntake)
            response["energyBalance"] = newBalance
        }

        replyHandler(response)
    }

    func sendUpdateToWatch(update: [String: Any]) {
        if session.isReachable {
            var formattedUpdate = update
            formattedUpdate["appState"] = appState
            session.sendMessage(formattedUpdate, replyHandler: nil, errorHandler: { error in
                print("Error sending message: \(error.localizedDescription)")
            })
            print("Message sent to watch.")
        } else {
            print("Session is not reachable for watch update. Ensure the watch app is in the foreground.")
        }
    }

    private func receiveNewWaterIntakeFromWatch(intake: Int) {
        DispatchQueue.main.async {
            self.addConsumption(EntryType.water, intake)
        }
    }

    private func receiveNewEnergyIntakeFromWatch(intake: Int) {
        DispatchQueue.main.async {
            self.addConsumption(EntryType.energy, intake)
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if let error = error {
            print("WCSession activation error: \(error.localizedDescription)")
        }

        switch activationState {
        case .activated:
            print("WCSession activated and ready for communication with the watch.")

        case .inactive:
            print("WCSession is inactive.")
        case .notActivated:
            print("WCSession not activated.")
        @unknown default:
            print("Unknown WCSession activation state.")
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session with watch went inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("Session with watch was deactivated")
    }
}
