//
//  HeaderView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI
import Foundation

struct HeaderView: View {
    @Binding var progress: Double
    @Binding var selectedTab: any ITabItem
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                //Spacer()
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(height: 60)
                        .foregroundColor(.baseInvert)
                        .shadow(color: .black, radius: 10)
                    
                    UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 5, topTrailing: 5))
                        .frame(width: max(geometry.size.width * min(progress, 1) + 20, 0), height: 60)
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

