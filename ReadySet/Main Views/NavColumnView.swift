//
//  NavColumnView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct NavColumnView: View {
    @State var exerciseViewModel: ExerciseViewModel
    @State var waterViewModel: WaterViewModel
    @State var energyViewModel: EnergyViewModel

    @Binding var tabItems: [any ITabItem]
    @Binding var selectedTab: any ITabItem
    @Binding var navigationDragHeight: Double

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                ForEach(tabItems, id: \.type) { tabItem in
                    Button(action: {
                        selectTab(tabItem)
                    }) {
                        tabImage(tabItem)
                    }
                    .padding(.leading, 5)
                    .buttonStyle(.plain)
                }

                dividerView
            }
            .frame(height: 120)
            .padding(.top, 8)
            detailColumn
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 10)
    }

    private func selectTab(_ tabItem: any ITabItem) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        withAnimation(.snappy) {
            selectedTab = tabItem
            tabItems = selectedTab.reorderTabs()
        }
    }

    private func tabImage(_ tabItem: any ITabItem) -> some View {
        Image(tabItem.icon)
            .resizable()
            .renderingMode(selectedTab.type == tabItem.type ? .original : .template)
            .frame(width: selectedTab.type == tabItem.type ? 30 : 20, height: selectedTab.type == tabItem.type ? 30 : 20)
            .foregroundStyle(tabItem.color)
            .colorMultiply(.white)
            .transition(.opacity)
    }

    private var dividerView: some View {
        Rectangle()
            .frame(width: 30, height: 2)
            .foregroundStyle(.gray)
            .cornerRadius(10)
            .shadow(radius: 1, y: 1)
    }

    private var detailColumn: some View {
        VStack(spacing: 0) {
            HStack {
                Text(selectedTab.text)
                    .bold()
                    .font(.system(size: 30))
                    .padding(.leading, 8)
                    .shadow(radius: 2)
                    .foregroundStyle(selectedTab.gradient)
                    .transition(.opacity)

                Spacer()
            }

            TopDetailView(exerciseViewModel: exerciseViewModel, waterViewModel: waterViewModel, energyViewModel: energyViewModel, selectedTab: $selectedTab)
                .blur(radius: abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.03) : 0)
        }
        .frame(height: 120)
    }
}

#Preview {
    NavColumnView(exerciseViewModel: ExerciseViewModel(), waterViewModel: WaterViewModel(), energyViewModel: EnergyViewModel(), tabItems: .constant(TabItemType.allItems), selectedTab: .constant(ExerciseTabItem()), navigationDragHeight: .constant(0))
        .ignoresSafeArea()
}
