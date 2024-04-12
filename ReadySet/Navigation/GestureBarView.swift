//
//  GestureBarView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/11/24.
//

import SwiftUI

struct GestureBarView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    @Binding var showGestureModal: Bool
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 100)
    
    var body: some View {
        ZStack {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(0..<1000) { _ in
                    Image(systemName: "plus")
                        .scaleEffect(0.4)
                        .frame(width: 2)
                }
            }
            .frame(width: 320, height: 90)
            .mask {
                Rectangle()
                    .frame(width: 320, height: 90)
                    .cornerRadius(50)
            }
            .offset(y: -5)
            
            Rectangle()
                .frame(height: 110)
                .cornerRadius(50)
                .padding(.bottom, 15)
                .foregroundStyle(.ultraThinMaterial)
                .opacity(0.85)
        }
        .padding(.horizontal)
    }
}

#Preview {
    GestureBarView(homeViewModel: HomeViewModel(), showGestureModal: .constant(false))
}
