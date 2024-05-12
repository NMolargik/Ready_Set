//
//  BouncingChevronView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI

struct BouncingChevronView: View {
    @State private var bounce = false

    let animationDistance: CGFloat = 8
    let animationDuration = 2.0

    var body: some View {
        Image(systemName: "chevron.up")
            .font(.body)
            .foregroundStyle(.fontGray)
            .offset(y: bounce ? -animationDistance : animationDistance)
            .animation(Animation.easeInOut(duration: animationDuration).repeatForever(autoreverses: true), value: bounce)
            .onAppear {
                self.bounce = true
            }
    }
}

#Preview {
    BouncingChevronView()
}
