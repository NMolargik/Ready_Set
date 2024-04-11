//
//  HeaderView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct HeaderView: View {
    @Binding var selectedTab: any ITabItem
    
    var body: some View {
        VStack (spacing: 0) {
            Spacer()
            
            HStack {
                Text("Hey, Nicholas")
                    .bold()
                
                Spacer()
                
                Text("Weather")
                    .bold()
            }
            .foregroundStyle(Color("FontGray"))
            .font(.caption)
            .padding(.vertical, 15)
            .padding(.horizontal)
            
            HStack (spacing: 0) {
                Rectangle()
                    .frame(width: 100, height: 5)
                    .foregroundStyle(selectedTab.gradient)
                    .shadow(color: selectedTab.color, radius: 5, x: 0, y: 5)
                
                Rectangle()
                    .frame(height: 5)
                    .foregroundStyle(.fontGray)
                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
            }
            
        }
        .frame(height: 90)
        .background {
            Rectangle()
                .foregroundStyle(.ultraThinMaterial)
        }
    }
}

#Preview {
    HeaderView(selectedTab: .constant(ExerciseTabItem()))
}
