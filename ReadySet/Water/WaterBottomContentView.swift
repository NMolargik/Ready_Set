//
//  WaterBottomContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct WaterBottomContentView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(35)
                .foregroundStyle(.ultraThinMaterial)
                .shadow(radius: 1)
            
            VStack {
                Spacer()
                
            }
            
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 15)
    }
}

#Preview {
    WaterBottomContentView()
}
