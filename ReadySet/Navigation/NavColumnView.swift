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
    @Binding var navigationDragHeight: Double
    @Binding var showBottomSheet: Bool
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                ForEach(tabItems, id: \.type) { tabItem in
                    Button(action: {
                        withAnimation (.snappy) {
                            selectedTab = tabItem
                            tabItems = selectedTab.reorderTabs()
                        }
                    }, label: {
                        Image(tabItem.icon)
                            .resizable()
                            .renderingMode(selectedTab.type == tabItem.type ? .original : .template)
                            .frame(width: selectedTab.type == tabItem.type ? 30 : 20, height: selectedTab.type == tabItem.type ? 30 : 20)
                            .foregroundStyle(selectedTab.type == tabItem.type ? .base : tabItem.color)
                            .transition(.opacity)
                        
                    })
                    .padding(.leading, 5)
                    .disabled(tabItem.type == selectedTab.type)
                }
            }
            .frame(height: 120)
            
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
                    
                    if (selectedTab.type != .settings) {
                        Button(action: {
                            withAnimation {
                                showBottomSheet = true
                            }
                        }, label: {
                            ZStack {
                                Capsule()
                                    .frame(width: 70, height: 30)
                                    .foregroundStyle(.thinMaterial)
                                    .shadow(radius: 1)
                                
                                HStack {
                                    Text("Edit")
                                        .bold()
                                        
                                    
                                    Image(systemName: "pencil")
                                }
                                .foregroundStyle(selectedTab.color)
                                .font(.system(size: 15))
                                .id("Edit")
                            }
                        })
                    }
                }
                
                TopDetailView(selectedTab: $selectedTab)
                    .blur(radius: abs(navigationDragHeight) > 20.0 ? abs(navigationDragHeight * 0.01) : 0)
            }
            .frame(height: 120)
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    NavColumnView(tabItems: .constant(TabItemType.allItems), selectedTab: .constant(ExerciseTabItem()), navigationDragHeight: .constant(0), showBottomSheet: .constant(false))
        .ignoresSafeArea()
}
