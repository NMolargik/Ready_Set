//
//  PhoneConnector.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import Foundation
import WatchConnectivity
import SwiftUI

class PhoneConnector: NSObject, WCSessionDelegate, ObservableObject {
    @Published var isConnected = false

    var session: WCSession
    var respondToPhoneUpdate: (([String: Any]) -> Void)

    init(session: WCSession = .default) {
        self.session = session
        self.respondToPhoneUpdate = { _ in }

        super.init()
        session.delegate = self
        session.activate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            switch activationState {
            case .activated:
                self.isConnected = true
                print("WCSession is activated and the phone is connected.")
            case .inactive, .notActivated:
                self.isConnected = false
                if let error = error {
                    print("WCSession activation failed with error: \(error.localizedDescription)")
                }
            @unknown default:
                print("Unknown activation state.")
            }
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        let update = self.buildResponseOutput(response: message)
        self.respondToPhoneUpdate(update)
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        print("Here now")
    }

    func requestInitialsFromPhone(completion: @escaping ([String: Any]) -> Void) {
        if session.isReachable {
            let payload: [String: Any] = [
                "giveAppState": true,
                "giveUseMetric": true,
                "giveStepGoal": true,
                "giveWaterGoal": true,
                "giveEnergyGoal": true,
                "giveStepBalance": true,
                "giveWaterBalance": true,
                "giveEnergyBalance": true
            ]

            session.sendMessage(payload) { response in
                let output = self.buildResponseOutput(response: response)
                DispatchQueue.main.async {
                    self.isConnected = true
                }
                completion(output)
            }
        }
    }

    func requestValuesFromPhone(values: [String], completion: @escaping ([String: Any]) -> Void) {
        var payload: [String: Any] = [:]

        for value in values {
            payload[value] = true
        }

        if session.isReachable {
            session.sendMessage(payload) { response in
                let output = self.buildResponseOutput(response: response)
                completion(output)
            }
        } else {
            let output = self.buildResponseOutput(response: ["appState": "inoperable"])
            completion(output)
        }
    }

    func sendNewIntakeToPhone(intake: Int, entryType: EntryType, completion: @escaping (Bool) -> Void) {
        if session.isReachable {
            let payload: [String: Any] = [(entryType == .water ? "newWaterIntake" : "newEnergyIntake"): intake]

            session.sendMessage(payload, replyHandler: { response in
                if response["complete"] is Bool {
                    completion(true)
                } else {
                    completion(false)
                }
            }, errorHandler: { error in
                DispatchQueue.main.async {
                    print("Error sending message: \(error.localizedDescription)")
                    completion(false)
                }
            })
        } else {
            DispatchQueue.main.async {
                print("Session is not reachable for intake report")
                completion(false)
            }
        }
    }

    func buildResponseOutput(response: [String: Any]) -> [String: Any] {
        var output: [String: Any] = [:]

        if let appState = response["appState"] as? String {
            output["appState"] = appState
        }

        if let useMetric = response["useMetric"] as? Bool {
            output["useMetric"] = useMetric
        }

        if let stepGoal = response["stepGoal"] as? Double {
            print(stepGoal)
            output["stepGoal"] = stepGoal
        }

        if let waterGoal = response["waterGoal"] as? Double {
            output["waterGoal"] = waterGoal
        }

        if let energyGoal = response["energyGoal"] as? Double {
            output["energyGoal"] = energyGoal
        }

        if let stepBalance = response["stepBalance"] as? Int {
            output["stepBalance"] = stepBalance
        }

        if let waterBalance = response["waterBalance"] as? Int {
            output["waterBalance"] = waterBalance
        }

        if let energyBalance = response["energyBalance"] as? Int {
            output["energyBalance"] = energyBalance
        }

        return output
    }
}
