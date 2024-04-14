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
    
    var body: some View {
        HStack (spacing: 5) {
            ZStack {
                Rectangle()
                    .frame(height: 80)
                    .cornerRadius(20)
                    .foregroundStyle(.thinMaterial)
                    .shadow(radius: 1)
                
                WaterWave(progress: min(CGFloat(waterViewModel.waterConsumed / waterViewModel.waterGoal), 0.98), waveHeight: 0.05, offset: startAnimation)
                    .fill(LinearGradient(colors: [.blueStart, .blueEnd], startPoint: .top, endPoint: .bottom))
                    .overlay(content: {
                        ZStack {
                            if (waterViewModel.waterConsumed / waterViewModel.waterGoal > Int(0.5)) {
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
                                .frame(width: 80, height: 30)
                                .cornerRadius(20)
                                .foregroundStyle(.ultraThinMaterial)
                                .shadow(radius: 2)
                                .offset(y: 20)
                                
                            
                            Text("\(waterViewModel.waterConsumed) of \(waterViewModel.waterGoal) oz")
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
            }
        }
        .padding(.leading, 8)
        .padding(.top, 5)
        .onAppear {
            waterViewModel.getWaterTodayFromHK()
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                startAnimation = 350
            }
        }
    }
}

#Preview {
    WaterTopContentView(waterViewModel: WaterViewModel())
}
