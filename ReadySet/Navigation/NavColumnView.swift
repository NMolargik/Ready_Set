//
//  NavColumnView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct NavColumnView: View {
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    @ObservedObject var waterViewModel: WaterViewModel
    @ObservedObject var calorieViewModel: CalorieViewModel

    @Binding var tabItems: [any ITabItem]
    @Binding var selectedTab: any ITabItem
    @Binding var navigationDragHeight: Double
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                ForEach(tabItems, id: \.type) { tabItem in
                    Button(action: {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        
                        withAnimation (.snappy) {
                            selectedTab = tabItem
                            tabItems = selectedTab.reorderTabs()
                        }
                    }, label: {
                        Image(tabItem.icon)
                            .resizable()
                            .renderingMode(selectedTab.type == tabItem.type ? .original : .template)
                            .frame(width: selectedTab.type == tabItem.type ? 30 : 20, height: selectedTab.type == tabItem.type ? 30 : 20)
                            .foregroundStyle(tabItem.color)
                            .transition(.opacity)
                    })
                    .padding(.leading, 5)
                    .disabled(tabItem.type == selectedTab.type)
                }
                
                Rectangle()
                    .frame(width: 30, height: 2)
                    .foregroundStyle(.gray)
                    .cornerRadius(10)
                    .shadow(radius: 1, y: 1)
            }
            .frame(height: 120)
            .padding(.top, 8)
            
            VStack (spacing: 0) {
                HStack {
                    Group {
                        if #available(iOS 17.0, *) {
                            Text(selectedTab.text)
                                .transition(.blurReplace)
                                
                        } else {
                            Text(selectedTab.text)
                                .transition(.opacity)
                        }
                    }
                    .bold()
                    .font(.system(size: 30)).padding(.leading, 8)
                    .shadow(radius: 2)
                    .foregroundStyle(selectedTab.gradient)
                    
                    Spacer()
                }
                
                TopDetailView(exerciseViewModel: exerciseViewModel, waterViewModel: waterViewModel, calorieViewModel: calorieViewModel, selectedTab: $selectedTab)
                    .blur(radius: abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.01) : 0)
            }
            .frame(height: 120)
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 10)
    }
}

#Preview {
    NavColumnView(exerciseViewModel: ExerciseViewModel(), waterViewModel: WaterViewModel(), calorieViewModel: CalorieViewModel(), tabItems: .constant(TabItemType.allItems), selectedTab: .constant(ExerciseTabItem()), navigationDragHeight: .constant(0))
        .ignoresSafeArea()
}
