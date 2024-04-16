//
//  WaterTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct WaterTopContentView: View {
    @ObservedObject var waterViewModel: WaterViewModel
    
    @State private var startAnimation: CGFloat = 0
    @State private var waterSliderValue: Double = 8
    
    var body: some View {
            ZStack {
                if (waterViewModel.editingWaterGoal) {
                    SliderView(range: 8...169, gradient: WaterTabItem().gradient, step: 8, label: "ounces", sliderValue: $waterSliderValue)
                        .onAppear {
                            waterSliderValue = waterViewModel.waterGoal
                        }
                        .onChange(of: waterSliderValue) { _ in
                            waterViewModel.proposedWaterGoal = Int(waterSliderValue)
                        }
                    .zIndex(2)
                    .id("WaterBottle")
                    
                } else {
                    Group {
                        Rectangle()
                            .frame(height: 80)
                            .cornerRadius(20)
                            .foregroundStyle(.thinMaterial)
                            .shadow(radius: 1)
                            .zIndex(1)
                        
                        WaterWave(progress: min(CGFloat(Double(waterViewModel.waterConsumedToday) / waterViewModel.waterGoal), 0.98), waveHeight: 0.07, offset: startAnimation)
                            .fill(LinearGradient(colors: [.blueStart, .blueEnd], startPoint: .top, endPoint: .bottom))
                            .overlay(content: {
                                waterWaveOverlay
                            })
                            .mask {
                                Rectangle()
                                    .frame(height: 80)
                                    .cornerRadius(20)
                                    .foregroundStyle(.thinMaterial)
                            }
                            .zIndex(2)
                            .id("WaterBottle")
                            .animation(.easeInOut(duration: 0.2), value: waterViewModel.editingWaterGoal)
                            .transition(.opacity)
                    }
                    .transition(.opacity)
                }

                HStack {
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            if (waterViewModel.editingWaterGoal) {
                                waterViewModel.saveWaterGoal()
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
        .padding(.leading, 8)
        .padding(.top, 5)
        .onAppear {
            withAnimation {
                waterViewModel.readInitial()
            }
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
    
    private var waterWaveOverlay: some View {
        Text("\(waterViewModel.waterConsumedToday) of \(Int(waterViewModel.waterGoal)) oz")
            .bold()
            .foregroundStyle(.secondary)
            .offset(y: 20)
            .padding(.horizontal, 5)
            .background {
                Rectangle()
                    .frame(height: 30)
                    .cornerRadius(20)
                    .foregroundStyle(.ultraThinMaterial)
                    .shadow(radius: 2)
                    .offset(y: 20)
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
