//
//  HomeView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

enum Tab {
    case exercise
    case water
    case calories
    case metrics
}

struct HomeView: View {
    @State var selectedTab = Tab.exercise
    
    var body: some View {
        VStack {
            HeaderView(selectedTab: $selectedTab)
            //Header View
            
            
            
            
            HStack {
                // Nav Column view
                
                // Content View
                
                
            }
        }
    }
}

#Preview {
    HomeView()
}
