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
            
            ZStack {
                Image(systemName: "chevron.down")
                    .foregroundStyle(Color("FontGray"))
                    .padding(.top, 5)
                
                HStack {
                    Text("Hey, Nicholas")
                        .bold()
                    
                    Spacer()
                    
                    Text("Weather")
                        .bold()
                }
                .foregroundStyle(Color("FontGray"))
                .font(.caption)
            }
            .padding(.vertical, 15)
            .padding(.horizontal)
            
            HStack (spacing: 0) {
                Rectangle()
                    .frame(width: 100, height: 5)
                    .foregroundStyle(selectedTab.color)
                    .shadow(color: selectedTab.color, radius: 5, x: 0, y: 3)
                
                Rectangle()
                    .frame(height: 5)
                    .foregroundStyle(.secondary)
                    .shadow(color: .black, radius: 5, x: 0, y: 5)
            }
        }
        .frame(height: 90)
        .background {
            Rectangle()
                .foregroundStyle(.ultraThickMaterial)
        }
    }
}

#Preview {
    HeaderView(selectedTab: .constant(ExerciseTabItem()))
}
