//
//  WaterTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct WaterTopContentView: View {
    @ObservedObject var waterViewModel: WaterViewModel
    @State var startAnimation: CGFloat = 0
    @State var waterSliderValue: Double = 1
    
    var body: some View {
        HStack (spacing: 5) {
            if (waterViewModel.editingWaterGoal) {
                HStack (alignment: .firstTextBaseline, spacing: 0) {
                    Text("\(Int(waterSliderValue))")
                        .bold()
                        .font(.title)
                        .id(waterSliderValue.description)

                    Text(" oz")
                        .bold()
                        .font(.caption2)
                }
                .frame(width: 80)
                .transition(.move(edge: .trailing))
            }

            ZStack {
                Group {
                    Rectangle()
                        .frame(height: 80)
                        .cornerRadius(20)
                        .foregroundStyle(.thinMaterial)
                        .shadow(radius: 1)
                        .zIndex(1)
                    
                    if (waterViewModel.editingWaterGoal) {
                        HStack {
                            ZStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [.blueStart, .blueEnd]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .mask(Slider(value: $waterSliderValue, in: 8...160, step: 8))
                                
                                Slider(value: $waterSliderValue, in: 8...160, step: 8)
                                    .opacity(0.05)
                            }
                            .onAppear {
                                waterSliderValue = waterViewModel.waterGoal
                            }
                            .onChange(of: waterSliderValue) { _ in
                                UINotificationFeedbackGenerator().notificationOccurred(.warning) //TODO: make custom haptics and extract them
                                waterViewModel.proposedWaterGoal = Int(waterSliderValue)
                            }
                            .padding(.horizontal)
                        }
                        .zIndex(2)
                        .id("WaterBottle")
                        
                    } else {
                        WaterWave(progress: min(CGFloat(Double(waterViewModel.waterConsumedToday) / waterViewModel.waterGoal), 0.98), waveHeight: 0.07, offset: startAnimation)
                            .fill(LinearGradient(colors: [.blueStart, .blueEnd], startPoint: .top, endPoint: .bottom))
                            .overlay(content: {
                                ZStack {
                                    if (waterViewModel.waterConsumedToday / Int(waterViewModel.waterGoal) > Int(0.5)) {
                                        Circle()
                                            .fill(.white.opacity(0.1))
                                            .frame(width: 15, height: 15)
                                            .offset(x: -20)
                                        
                                        Circle()
                                            .fill(.white.opacity(0.1))
                                            .frame(width: 15, height: 15)
                                            .offset(x: 70, y: 10)
                                        
                                        Circle()
                                            .fill(.white.opacity(0.1))
                                            .frame(width: 25, height: 25)
                                            .offset(x: -80, y: 2)
                                    }
                                    
                                    Rectangle()
                                        .frame(width: 120, height: 30)
                                        .cornerRadius(20)
                                        .foregroundStyle(.ultraThinMaterial)
                                        .shadow(radius: 2)
                                        .offset(y: 20)
                                    
                                    
                                    Text("\(waterViewModel.waterConsumedToday) of \(Int(waterViewModel.waterGoal)) oz")
                                        .bold()
                                        .foregroundStyle(.secondary)
                                        .offset(y: 20)
                                }
                            })
                            .mask {
                                Rectangle()
                                    .frame(height: 80)
                                    .cornerRadius(20)
                                    .foregroundStyle(.thinMaterial)
                            }
                            .zIndex(2)
                            .id("WaterBottle")
                            .transition(.identity)
                    }
                }

                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            if (waterViewModel.editingWaterGoal) {
                                waterViewModel.saveWaterGoal()
                                waterViewModel.editingWaterGoal = false
                            } else {
                                waterViewModel.editingWaterGoal = true
                            }
                        }
                    }, label: {
                        Text(waterViewModel.editingWaterGoal ? "Save Goal" : "Edit Goal")
                            .bold()
                            .foregroundStyle(.blueEnd)
                            .transition(.opacity)
                    })
                }
                .offset(y: -62)
            }
        }
        .padding(.leading, 8)
        .padding(.top, 5)
        .onAppear {
            waterViewModel.readWaterConsumedToday()
            waterViewModel.readWaterConsumedWeek()
            startAnimationIfNeeded()
        }
        .onChange(of: waterViewModel.editingWaterGoal) { editing in
            if !editing {
                withAnimation(.easeOut(duration: 0.5)) {
                    startAnimation = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    startAnimationIfNeeded()
                }
            }
        }
    }
    
    private func startAnimationIfNeeded() {
        withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
            startAnimation = 360
        }
    }
}

#Preview {
    WaterTopContentView(waterViewModel: WaterViewModel())
}
