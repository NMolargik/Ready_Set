//
//  HeaderView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct HeaderView: View {
    @Binding var progress: Double
    @Binding var selectedTab: any ITabItem
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(height: 60)
                        .foregroundStyle(.baseAccent)
                        .shadow(color: .black, radius: 10)
                    
                    Rectangle()
                        .frame(width: max(0.05 * geometry.size.width, min(geometry.size.width * min(progress, 1), geometry.size.width)), height: 60)
                        .foregroundStyle(selectedTab.gradient)
                        .shadow(color: selectedTab.secondaryColor, radius: 8, x: 0, y: 0)
                        .animation(.easeInOut(duration: 1), value: progress)
                }
            }
        }
        .frame(height: 60)
    }
}

#Preview {
    HeaderView(progress: .constant(0.1), selectedTab: .constant(ExerciseTabItem()))
}

