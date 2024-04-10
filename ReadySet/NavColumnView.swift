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
                HStack {
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
                                .font(.system(size: selectedTab.text == tabItem.text ? 30 : 10))
                                .frame(width: 30, height: 20)
                            
                            if (tabItem.text == selectedTab.text) {
                                if #available(iOS 17.0, *) {
                                    Text(tabItem.text)
                                        .bold()
                                        .font(.system(size: selectedTab.text == tabItem.text ? 30 : 10))
                                        .transition(.blurReplace)
                                        .padding(.leading, 8)
                                } else {
                                    Text(tabItem.text)
                                        .bold()
                                        .font(.system(size: selectedTab.text == tabItem.text ? 30 : 10))
                                        .transition(.opacity)
                                        .padding(.leading, 8)
                                }
                            }
                        }
                    })
                    .foregroundStyle(selectedTab.text == tabItem.text ? tabItem.color : Color("FontGray"), selectedTab.text == tabItem.text ? tabItem.color : Color("FontGray"))
                    .padding(.leading, 5)
                    .disabled(tabItem.text == selectedTab.text)
                    
                    Spacer()
                    
                    if (tabItem.text == selectedTab.text) {
                        Button(action: {
                            
                        }, label: {
                            ZStack {
                                Capsule()
                                    .frame(width: 70, height: 30)
                                    .foregroundStyle(.ultraThickMaterial)
                                    .shadow(color: .black, radius: 1)
                                
                                HStack {
                                    Text("Edit")
                                        .bold()
                                    
                                    Image(systemName: "pencil")
                                }
                                .font(.system(size: 15))
                                .foregroundStyle(selectedTab.color)
                            }
                        })
                    }
                }
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
