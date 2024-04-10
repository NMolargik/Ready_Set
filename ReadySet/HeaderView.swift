//
//  HeaderView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct HeaderView: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        VStack {
            HStack {
                Text("Hello, Nick")
                
                Spacer()
                
                Text("Day 1")
            }
            .padding(.horizontal)
        }
        .background(.ultraThinMaterial)
    }
}

#Preview {
    HeaderView(selectedTab: .constant(Tab.exercise))
}
