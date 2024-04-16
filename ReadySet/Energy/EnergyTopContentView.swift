//
//  EnergyTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct EnergyTopContentView: View {
    @AppStorage("useMetric") var useMetric: Bool = false
    
    @ObservedObject var energyViewModel: EnergyViewModel
    @State private var energysliderValue: Double = 0
    
    var body: some View {
        HStack(spacing: 5) {
            ZStack {
                if energyViewModel.editingEnergyGoal {
                    SliderView(range: (useMetric ? 4184 : 1000)...(useMetric ? 20920 : 5000), gradient: EnergyTabItem().gradient, step: 100, label: useMetric ? "kJ" : "cal", sliderValue: $energysliderValue)
                        .onAppear {
                            energysliderValue = energyViewModel.energyGoal
                        }
                        .onChange(of: energysliderValue) { _ in
                            energyViewModel.proposedEnergyGoal = Int(energysliderValue)
                        }
                        
                } else {
                    EnergyDisplay
                }
                
                editGoalButton
            }
        }
        .padding(.leading, 8)
        .padding(.top, 5)
        .onAppear {
            withAnimation {
                energyViewModel.readInitial()
            }
        }
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
                Text("\(Int(energyViewModel.energyConsumedToday)) / \(Int(energyViewModel.energyGoal)) Consumed")
                    .bold()
                    .foregroundColor(.fontGray)
                
                Text("~\(Int(energyViewModel.energyBurnedToday)) Burned")
                    .bold()
                    .foregroundColor(.fontGray)
            }
            Spacer()
            EnergyFitnessWidgetView()
            EnergyHealthWidgetView()
        }
    }

    private var editGoalButton: some View {
        HStack {
            Spacer()
            
            Button(action: {
                withAnimation {
                    if (energyViewModel.editingEnergyGoal) {
                        energyViewModel.saveEnergyGoal()
                    } else {
                        energyViewModel.editingEnergyGoal = true
                    }
                }
            }) {
                Text(energyViewModel.editingEnergyGoal ? "Save Goal" : "Edit Goal")
                    .bold()
                    .foregroundStyle(.orangeEnd)
                    .transition(.opacity)
            }
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
