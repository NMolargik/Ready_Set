//
//  BottomView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct BottomView: View {
    @AppStorage("moveNavToRight") var moveNavToRight: Bool = false

    @ObservedObject var exerciseViewModel: ExerciseViewModel
    @ObservedObject var waterViewModel: WaterViewModel
    @ObservedObject var energyViewModel: EnergyViewModel
    @Binding var selectedTab: any ITabItem
    @Binding var selectedDay: Int
    @Binding var blurRadius: CGFloat
    @Binding var offset: Double

    var dragGesture: AnyGesture<DragGesture.Value>

    var body: some View {
        HStack {
            if !moveNavToRight && !exerciseViewModel.editingSets {
                DragAreaView(offset: $offset)
                    .gesture(dragGesture)
                    .transition(.move(edge: .leading).combined(with: .blurReplace))
                    .padding(.vertical, 5)
            }

            ZStack {
                Rectangle()
                    .cornerRadius(35)
                    .foregroundStyle(.ultraThinMaterial)
                    .shadow(radius: 1)
                    .animation(.easeInOut(duration: 0.5), value: selectedTab.type)

                Group {
                    switch selectedTab.type {
                    case .exercise:
                        ExerciseBottomContentView(exerciseViewModel: exerciseViewModel, selectedDay: $selectedDay)
                    case .water:
                        WaterBottomContentView(waterViewModel: waterViewModel)
                    case .energy:
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
            .transition(.opacity)
            .blur(radius: blurRadius)

            if moveNavToRight {
                DragAreaView(offset: $offset)
                    .gesture(dragGesture)
                    .transition(.move(edge: .trailing).combined(with: .blurReplace))
            }
        }
        .animation(.easeInOut, value: moveNavToRight)
    }
}

#Preview {
    BottomView(
        exerciseViewModel: ExerciseViewModel(),
        waterViewModel: WaterViewModel(),
        energyViewModel: EnergyViewModel(),
        selectedTab: .constant(ExerciseTabItem()),
        selectedDay: .constant(0),
        blurRadius: .constant(0.0),
        offset: .constant(0.0),
        dragGesture: AnyGesture(DragGesture().onChanged { _ in })
    )
}
