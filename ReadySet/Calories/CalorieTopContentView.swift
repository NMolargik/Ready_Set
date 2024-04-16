//
//  CalorieTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct CalorieTopContentView: View {
    @ObservedObject var calorieViewModel: CalorieViewModel
    @State private var calorieSliderValue: Double = 0
    
    var body: some View {
        HStack(spacing: 5) {
            ZStack {
                if calorieViewModel.editingCalorieGoal {
                    SliderView(range: 1000...5000, gradient: CalorieTabItem().gradient, step: 100, label: "cal", sliderValue: $calorieSliderValue)
                        .onAppear {
                            calorieSliderValue = calorieViewModel.calorieGoal
                        }
                        .onChange(of: calorieSliderValue) { _ in
                            calorieViewModel.proposedCalorieGoal = Int(calorieSliderValue)
                        }
                        
                } else {
                    calorieDisplay
                }
                
                editGoalButton
            }
        }
        .padding(.leading, 8)
        .padding(.top, 5)
        .onAppear {
            withAnimation {
                calorieViewModel.readInitial()
            }
        }
    }

    private var calorieDisplay: some View {
        VStack {
            Gauge(value: min(calorieViewModel.calorieGoal, Double(calorieViewModel.caloriesConsumedToday)), in: 0...calorieViewModel.calorieGoal) {
                EmptyView()
            }
            .tint(CalorieTabItem().gradient)
            .animation(.easeInOut, value: calorieViewModel.caloriesConsumedToday)
            
            calorieConsumptionDetails
            Spacer()
        }
        .zIndex(1)
        .id("CalorieGauge")
    }

    private var calorieConsumptionDetails: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(Int(calorieViewModel.caloriesConsumedToday)) / \(Int(calorieViewModel.calorieGoal)) Consumed")
                    .bold()
                    .foregroundColor(.fontGray)
                
                Text("~\(Int(calorieViewModel.caloriesBurnedToday)) Burned")
                    .bold()
                    .foregroundColor(.fontGray)
            }
            Spacer()
            CalorieFitnessWidgetView()
            CalorieHealthWidgetView()
        }
    }

    private var editGoalButton: some View {
        HStack {
            Spacer()
            
            Button(action: {
                withAnimation {
                    if (calorieViewModel.editingCalorieGoal) {
                        calorieViewModel.saveCalorieGoal()
                    } else {
                        calorieViewModel.editingCalorieGoal = true
                    }
                }
            }) {
                Text(calorieViewModel.editingCalorieGoal ? "Save Goal" : "Edit Goal")
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
    CalorieTopContentView(calorieViewModel: CalorieViewModel())
}
