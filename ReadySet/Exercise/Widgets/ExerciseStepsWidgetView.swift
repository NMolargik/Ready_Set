//
//  ExerciseStepsWidgetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI
import HealthKit

struct ExerciseStepsWidgetView: View {
    @Environment(\.scenePhase) var scenePhase
    @Binding var stepCountGoal: Int
    @State private var stepCount = 1000
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 35)
                .cornerRadius(10)
                .foregroundStyle(.thinMaterial)
                .shadow(radius: 1)
            
            HStack {
                Image(systemName: "shoeprints.fill")
                
                Text("\(stepCount) / \(stepCountGoal)")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(.fontGray)
            .onChange(of: scenePhase) { newPhase in
                if  newPhase == .active {
                    withAnimation {
                        //TODO: refresh steps
                    }
                }
            }
        }
    }
    
    func readStepCountToday() {
        let healthStore = HKHealthStore()
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
          return
        }

        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
          withStart: startDate,
          end: now,
          options: .strictStartDate
        )

        let query = HKStatisticsQuery(
          quantityType: stepCountType,
          quantitySamplePredicate: predicate,
          options: .cumulativeSum
        ) {
          _, result, error in
          guard let result = result, let sum = result.sumQuantity() else {
            print("failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
            return
          }

          let steps = Int(sum.doubleValue(for: HKUnit.count()))
          self.stepCount = steps
        }
        healthStore.execute(query)
      }
}

#Preview {
    ExerciseStepsWidgetView(stepCountGoal: .constant(10000))
}
