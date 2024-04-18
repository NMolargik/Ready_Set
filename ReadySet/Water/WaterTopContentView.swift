//
//  WaterTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct WaterTopContentView: View {
    @AppStorage("useMetric") var useMetric: Bool = false
    @AppStorage("disableWave") var disableWave: Bool = false
    @AppStorage("decreaseHaptics") var decreaseHaptics: Bool = false
    
    @ObservedObject var waterViewModel: WaterViewModel
    
    @State private var startAnimation: CGFloat = 0
    @State private var waterSliderValue: Double = 8
    
    var body: some View {
            ZStack {
                if (waterViewModel.editingWaterGoal) {
                    SliderView(range: (useMetric ? 150 : 8)...(useMetric ? 4000 : 168), gradient: WaterTabItem().gradient, step: useMetric ? 50 : 8, label: useMetric ? "mL" : "ounces", sliderValue: $waterSliderValue)
                        .onAppear {
                            waterSliderValue = waterViewModel.waterGoal
                        }
                        .onChange(of: waterSliderValue) { _ in
                            if (!decreaseHaptics) {
                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                            }
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
                        
                        WaterWave(progress: min(1, CGFloat(Double(waterViewModel.waterConsumedToday) / waterViewModel.waterGoal)), waveHeight: disableWave ? 0.0 : 0.1, offset: startAnimation)
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
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        }
                    }, label: {
                        Text(waterViewModel.editingWaterGoal ? "Save Goal" : "Edit Goal")
                            .bold()
                            .foregroundStyle(.blueEnd)
                            .transition(.opacity)
                    })
                    .buttonStyle(.plain)
                }
                .offset(y: -62)
        }
        .padding(.leading, 8)
        .padding(.top, 5)
        .onAppear {
            if (!disableWave) {
                startAnimationIfNeeded()
            }
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
        Text("\(waterViewModel.waterConsumedToday) of \(Int(waterViewModel.waterGoal)) \(useMetric ? "ml" : "oz")")
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
