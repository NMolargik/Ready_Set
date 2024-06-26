//
//  EnergyTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct EnergyTopContentView: View {
    @ObservedObject var energyViewModel: EnergyViewModel

    var body: some View {
        HStack(spacing: 5) {
            ZStack {
                if energyViewModel.editingEnergyGoal {
                    SliderView(range: (energyViewModel.useMetric ? 4184 : 1000)...(energyViewModel.useMetric ? 20920 : 5000), gradient: EnergyTabItem().gradient, step: 100, label: energyViewModel.useMetric ? "kJ" : "cal", sliderValue: $energyViewModel.energySliderValue)
                        .onAppear {
                            energyViewModel.energySliderValue = energyViewModel.energyGoal
                        }
                } else {
                    EnergyDisplay
                }

                editGoalButton
            }
        }
        .padding(.leading, 8)
        .padding(.top, 5)
    }

    private var EnergyDisplay: some View {
        VStack {
            Gauge(value: min(energyViewModel.energyGoal, Double(energyViewModel.energyConsumedToday)), in: 0...energyViewModel.energyGoal) {
                EmptyView()
            }
            .tint(EnergyTabItem().gradient)
            .animation(.easeInOut, value: energyViewModel.energyConsumedToday)

            EnergyConsumptionDetails
            Spacer()
        }
        .zIndex(1)
        .id("EnergyGauge")
    }

    private var EnergyConsumptionDetails: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("~\(Int(energyViewModel.energyConsumedToday)) \(energyViewModel.useMetric ? "kJ" : "cal") Consumed")
                    .bold()
                    .foregroundStyle(.fontGray)

                Text("~\(Int(energyViewModel.energyBurnedToday)) Burned")
                    .bold()
                    .foregroundStyle(.fontGray)
            }
            Spacer()
            EnergyFitnessComponentView()
            EnergyHealthComponentView()
        }
    }

    private var editGoalButton: some View {
        HStack {
            Spacer()

            Button(action: {
                withAnimation {
                    if energyViewModel.editingEnergyGoal {
                        energyViewModel.saveEnergyGoal()
                    } else {
                        energyViewModel.editingEnergyGoal = true
                    }
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                }
            }) {
                Text(energyViewModel.editingEnergyGoal ? "Save Goal" : "Edit Goal")
                    .bold()
                    .foregroundStyle(.orangeEnd)
                    .transition(.opacity)
            }
            .buttonStyle(.plain)
            .offset(y: -62)
        }
    }

    private var defaultRectangle: some View {
        Rectangle()
            .frame(height: 80)
            .cornerRadius(20)
            .foregroundStyle(.thinMaterial)
            .shadow(radius: 1)
    }
}

#Preview {
    EnergyTopContentView(energyViewModel: EnergyViewModel())
}
