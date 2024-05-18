//
//  IncrementValueManager.swift
//  ReadySetWidgetsExtension
//
//  Created by Nick Molargik on 5/9/24.
//

import Foundation

struct IncrementValueManager {
    static let shared = IncrementValueManager()
    
    private let waterIncrementMetricKey = "waterIncrementMetric"
    private let waterIncrementImperialKey = "waterIncrementImperial"
    private let energyIncrementMetricKey = "energyIncrementMetric"
    private let energyIncrementImperialKey = "energyIncrementImperial"
    
    private init() {
        setWaterIncrement(value: 8, useMetric: false)
        setWaterIncrement(value: 240, useMetric: true)
        setEnergyIncrement(value: 200, useMetric: false)
        setEnergyIncrement(value: 1000, useMetric: true)
    }
    
    func getWaterIncrement(useMetric: Bool) -> Double {
        let key = useMetric ? waterIncrementMetricKey : waterIncrementImperialKey
        return UserDefaults.standard.double(forKey: key)
    }
    
    func setWaterIncrement(value: Double, useMetric: Bool) {
        let key = useMetric ? waterIncrementMetricKey : waterIncrementImperialKey
        UserDefaults.standard.set(value, forKey: key)
        print("Set water widget increment value to \(getWaterIncrement(useMetric: useMetric))")
    }
    
    func getEnergyIncrement(useMetric: Bool) -> Double {
        let key = useMetric ? energyIncrementMetricKey : energyIncrementImperialKey
        return UserDefaults.standard.double(forKey: key)
    }
    
    func setEnergyIncrement(value: Double, useMetric: Bool) {
        let key = useMetric ? energyIncrementMetricKey : energyIncrementImperialKey
        UserDefaults.standard.set(value, forKey: key)
        print("Set energy widget increment value to \(getEnergyIncrement(useMetric: useMetric))")
    }
}
