//
//  CalorieTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct CalorieTopContentView: View {
    @ObservedObject var calorieViewModel: CalorieViewModel
    
    @State private var opacity = 0.0
    @State private var showAlert = false
    @State private var calorieSliderValue: Double = 0
    
    private let minValue = 0.0
    private let maxValue = 570.0
    
    var body: some View {
        HStack (spacing: 5) {
            if (calorieViewModel.editingCalorieGoal) {
                HStack (alignment: .firstTextBaseline, spacing: 0) {
                    Text("\(Int(calorieSliderValue))")
                        .bold()
                        .font(.title)
                        .id(calorieSliderValue.description)

                    Text(" cal")
                        .bold()
                        .font(.caption2)
                }
                .frame(width: 110)
                .transition(.opacity)
            }
            
            ZStack {
                if (calorieViewModel.editingCalorieGoal) {
                    HStack {
                        ZStack {
                            CalorieTabItem().gradient
                            .mask(Slider(value: $calorieSliderValue, in: 1000...5000, step: 100))
                            
                            Slider(value: $calorieSliderValue, in: 1000...5000, step: 100)
                                .opacity(0.05)
                        }
                        .onAppear {
                            calorieSliderValue = calorieViewModel.calorieGoal
                        }
                        .onChange(of: calorieSliderValue) { _ in
                            UINotificationFeedbackGenerator().notificationOccurred(.warning) //TODO: make custom haptics and extract them
                            calorieViewModel.proposedCalorieGoal = Int(calorieSliderValue)
                        }
                        .padding(.horizontal)
                    }
                    .zIndex(1)
                    .id("CalorieGauge")
                } else {
                    VStack {
                        Gauge(value: min(calorieViewModel.calorieGoal, Double(calorieViewModel.caloriesConsumed)), in: 0...calorieViewModel.calorieGoal) {
                        }
                        .tint(CalorieTabItem().gradient)
                        .shadow(radius: 1)
                        .animation(.easeInOut, value: calorieViewModel.caloriesConsumed)
                        
                        HStack {
                            VStack (alignment: .leading) {
                                Text("\(Int(calorieViewModel.caloriesConsumed)) / \(Int(calorieViewModel.calorieGoal)) Consumed")
                                    .bold()
                                    .foregroundColor(.fontGray)
                                
                                Text("\(Int(calorieViewModel.caloriesBurned)) Burned")
                                    .bold()
                                    .foregroundColor(.fontGray)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                                guard let url = URL(string: "fitnessapp://") else { return }
                                
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url)
                                } else {
                                    showAlert = true
                                }
                            }, label: {
                                ZStack {
                                    Circle()
                                        .frame(height: 40)
                                        .cornerRadius(10)
                                        .foregroundStyle(.thinMaterial)
                                        .shadow(radius: 1)
                                    
                                    Image(systemName: "circle.circle")
                                        .foregroundStyle(.green, .red, .yellow)
                                }
                            })
                            
                            Button(action: {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                                UIApplication.shared.open(URL(string: "x-apple-health://")!)
                            }, label: {
                                ZStack {
                                    Circle()
                                        .frame(height: 40)
                                        .cornerRadius(10)
                                        .foregroundStyle(.thinMaterial)
                                        .shadow(radius: 1)
                                    
                                    Image(systemName: "heart")
                                        .foregroundStyle(.pink)
                                }
                            })
                        }
                        
                        Spacer()
                    }
                    .zIndex(1)
                    .id("CalorieGauge")
                    .alert("Fitness app not installed", isPresented: $showAlert) {
                        Button("Install", role: .cancel) { UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/fitness/id1208224953")!) }
                        Button("Cancel", role: .destructive) { showAlert.toggle() }
                    }
                }
                
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
                    }, label: {
                        Text(calorieViewModel.editingCalorieGoal ? "Save Goal" : "Edit Goal")
                            .bold()
                            .foregroundStyle(.orangeEnd)
                            .transition(.opacity)
                    })
                }
                .offset(y: -62)
            }
        }
        .padding(.leading, 8)
        .padding(.top, 5)
        .onAppear {
            calorieViewModel.readEnergyConsumedToday()
            calorieViewModel.readEnergyBurnedToday()
            calorieViewModel.readEnergyConsumedWeek()
            calorieViewModel.readEnergyBurnedWeek()
        }
    }
}

#Preview {
    CalorieTopContentView(calorieViewModel: CalorieViewModel())
}
