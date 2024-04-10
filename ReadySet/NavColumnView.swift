//
//  NavColumnView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct NavColumnView: View {
    @Binding var tabItems: [any ITabItem]
    @Binding var selectedTab: any ITabItem
    
    var body: some View {
        VStack (
            alignment: .leading) {
            ForEach(tabItems, id: \.type) { tabItem in
                HStack {
                    Button(action: {
                        withAnimation (.snappy) {
                            
                            selectedTab = tabItem
                            tabItems = selectedTab.reorderTabs()
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
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color("FontGray"), lineWidth: 1)
                                    )
                                
                                HStack {
                                    Text("Edit")
                                        .bold()
                                    
                                    Image(systemName: "pencil")
                                }
                                .font(.system(size: 15))
                                .foregroundStyle(selectedTab.color)
                                .id("Edit")
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
    NavColumnView(tabItems: .constant(TabItemType.allItems), selectedTab: .constant(ExerciseTabItem()))
        .ignoresSafeArea()
}
