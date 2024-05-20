//
//  WatchTrackerView.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/28/24.
//

import SwiftUI
import HealthKit

struct WatchTrackerView: View {
    var title: String
    var unit: String
    var gradient: LinearGradient
    var color: Color
    var iconName: String
    var systemIconName: String
    var min: Double
    @Binding var currentBalance: Int
    @Binding var goal: Double
    var step: Double
    var useMetric: Bool
    var addIntake: ((Int, @escaping (Bool) -> Void) -> Void)
    var requestBalanceUpdate: () -> Void

    @State private var isAdding: Bool = false
    @State private var isUpdating: Bool = false
    @State private var amountToAdd: Double = 0.0

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                GaugeView(max: $goal, level: $currentBalance, isUpdating: $isUpdating, color: color, unit: unit)
                    .frame(height: 120)

                if title != "Exercise" {
                    Button(action: {
                        withAnimation {
                            isAdding = true
                        }
                    }, label: {
                        ZStack {
                            Circle()
                                .foregroundStyle(.base)

                            Image(iconName)
                                .resizable()
                                .scaledToFill()
                                .padding(5)

                            Image(systemName: systemIconName)
                                .foregroundStyle(.base)
                                .offset(y: 3)
                        }
                    })
                        .buttonStyle(.plain)
                        .frame(width: 40)
                        .padding(.top, -20)
                }
            }
            .blur(radius: isAdding ? 20 : 0)
            .animation(.easeInOut, value: amountToAdd)
            .bold()
            .font(.system(size: 20))
            .animation(.easeInOut, value: goal)
            .transition(.blurReplace())

            if isAdding {
                CrownRotationAdditionView(amount: $amountToAdd, min: min, max: goal, step: step, unitOfMeasurement: useMetric ? unit : unit, gradient: gradient, onAdd: { amount in
                    withAnimation {
                        isAdding = false
                        isUpdating = true
                    }

                    if amount > 0 {
                        addIntake(Int(amount)) { _ in
                            WKInterfaceDevice.current().play(.success)

                            withAnimation {
                                amountToAdd = 0
                                isUpdating = false
                            }
                        }
                    } else {
                        withAnimation {
                            amountToAdd = 0
                            isUpdating = false
                        }
                    }
                }, onCancel: {
                    withAnimation {
                        amountToAdd = 0
                        isAdding = false
                    }
                })
                .onAppear {
                    amountToAdd = min
                }
            }
        }
        .onChange(of: currentBalance) {
            withAnimation {
                isUpdating = false
            }
        }
    }
}
