//
//  NavColumnView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct NavColumnView: View {
    @State private var tabItems = TabItemType.allItems
    @Binding var selectedTab: any ITabItem
    
    var body: some View {
        VStack (
            alignment: .leading) {
            ForEach(tabItems, id: \.text) { tabItem in
                Button(action: {
                    withAnimation (.snappy) {
                        
                        selectedTab = tabItem
                        switch (selectedTab.text) {
                        case "Exercise":
                            tabItems = [ExerciseTabItem(), MetricTabItem(), WaterTabItem(), CalorieTabItem()]
                        case "Metrics":
                            tabItems = [MetricTabItem(), WaterTabItem(), CalorieTabItem(), ExerciseTabItem()]
                        case "Water":
                            tabItems = [WaterTabItem(), CalorieTabItem(), ExerciseTabItem(), MetricTabItem()]
                        case "Calories":
                            tabItems = [CalorieTabItem(), ExerciseTabItem(), MetricTabItem(), WaterTabItem()]
                        default:
                            tabItems = [ExerciseTabItem(), MetricTabItem(), WaterTabItem(), CalorieTabItem()]
                            
                        }
                    }
                }, label: {
                    HStack {
                        Image(systemName: tabItem.selectedIconName)
                            .foregroundStyle(selectedTab.text == tabItem.text ? tabItem.color : Color("FontGray"), selectedTab.text == tabItem.text ? tabItem.color : Color("FontGray"))
                            .font(.system(size: selectedTab.text == tabItem.text ? 30 : 10))
                            .frame(width: 30, height: 20)
                            .padding(.horizontal, 5)
                        
                        if (tabItem.text == selectedTab.text) {
                            if #available(iOS 17.0, *) {
                                Text(tabItem.text)
                                    .bold()
                                    .foregroundStyle(selectedTab.text == tabItem.text ? tabItem.color : Color("FontGray"), Color("FontGray"))
                                    .font(.system(size: selectedTab.text == tabItem.text ? 30 : 10))
                                    .transition(.blurReplace)
                                    .padding(.leading, 5)
                            } else {
                                Text(tabItem.text)
                                    .bold()
                                    .foregroundStyle(selectedTab.text == tabItem.text ? tabItem.color : Color("FontGray"), Color("FontGray"))
                                    .font(.system(size: selectedTab.text == tabItem.text ? 30 : 10))
                                    .transition(.opacity)
                                    .padding(.leading, 5)
                            }
                        }
                    }
                })
            }
            
            Spacer()
        }
        .padding([.top, .leading], 8)
    }
}

#Preview {
    NavColumnView(selectedTab: .constant(ExerciseTabItem()))
        .ignoresSafeArea()
}
