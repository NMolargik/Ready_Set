//
//  HomeView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct HomeView: View {
    @State var selectedTab: any ITabItem = ExerciseTabItem()
    
    var body: some View {
        VStack {
            HeaderView(selectedTab: $selectedTab)
            
            ZStack {
                // Nav Column view
                HStack {
                    NavColumnView(selectedTab: $selectedTab)
                    
                    Spacer()
                }
                
                Text("Yo")
            }
            .frame(height: 150)
            
            
            Text("Yo Homie")
            
            Spacer()
            
        }
    }
}

#Preview {
    HomeView()
        .ignoresSafeArea()
}
