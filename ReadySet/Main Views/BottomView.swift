//
//  BottomView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct BottomView: View {
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    @ObservedObject var waterViewModel: WaterViewModel
    @ObservedObject var energyViewModel: EnergyViewModel
    @State private var selectedDay: Int = 1
    
    @Binding var selectedTab: any ITabItem
    
    var body: some View {
        ZStack {
            ZStack {
                Rectangle()
                    .cornerRadius(35)
                    .foregroundStyle(.ultraThinMaterial)
                    .shadow(radius: 1)
                    .animation(.easeInOut(duration: 0.5), value: selectedTab.type)
                
                Group {
                    switch (selectedTab.type) {
                    case .exercise:
                        ExerciseBottomContentView(exerciseViewModel: exerciseViewModel, selectedDay: $selectedDay)
                    case .water:
                        WaterBottomContentView(waterViewModel: waterViewModel)
                    case .Energy:
                        EnergyBottomContentView(energyViewModel: energyViewModel)
                    case .settings:
                        SettingsBottomContentView()
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: selectedTab.type)
                .mask {
                    Rectangle()
                        .cornerRadius(35)
                }
            }
            .geometryGroup()
            .onAppear {
                withAnimation {
                    exerciseViewModel.getCurrentWeekday()
                    selectedDay = exerciseViewModel.currentDay - 1
                }
            }
            .transition(.opacity)
            
            if (selectedTab.type == .exercise && !exerciseViewModel.expandedSets && !exerciseViewModel.editingSets) {
                VStack {
                    Spacer()
                    
                    LinearGradient(colors: [.green.opacity(0.5), .clear, .clear], startPoint: .bottom, endPoint: .top)
                        .frame(height: 70)
                        .mask {
                            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 30, bottomTrailing: 30))
                                .frame(height: 70)
                        }
                }
                .transition(.opacity)
                .zIndex(4)
            }
        }
    }
}

#Preview {
    BottomView(exerciseViewModel: ExerciseViewModel(), waterViewModel: WaterViewModel(), energyViewModel: EnergyViewModel(), selectedTab: .constant(ExerciseTabItem()))
}
