//
//  HeaderView.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import SwiftUI

struct HeaderView: View {
    @Binding var progress: Double
    @Binding var selectedTab: Int
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .cornerRadius(10)
                        .frame(height: 20)
                        .foregroundStyle(.gray)
                        .shadow(color: .black, radius: 10)
                    
                    Rectangle()
                        .cornerRadius(10)
                        .frame(width: max(0.1 * geometry.size.width, min(geometry.size.width * min(progress, 1), geometry.size.width)), height: 20)
                        .foregroundStyle(WatchTabItemType.allItems[selectedTab].gradient)
                        .shadow(color: WatchTabItemType.allItems[selectedTab].secondaryColor, radius: 4, x: 0, y: 0)
                        .animation(.easeInOut(duration: 1), value: progress)
                }
                .animation(.easeInOut, value: selectedTab)
            }
        }
        .frame(height: 60)
        .padding(.leading, 20)
        .padding(.trailing, 70)
        .padding(.top, 10)
        .ignoresSafeArea()
    }
}

#Preview {
    HeaderView(progress: .constant(0.1), selectedTab: .constant(0))
}

