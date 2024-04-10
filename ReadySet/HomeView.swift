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
            
            HStack {
                // Nav Column view
                NavColumnView(selectedTab: $selectedTab)
                
                Spacer()
            }
            
        }
    }
}

#Preview {
    HomeView()
        .ignoresSafeArea()
}
