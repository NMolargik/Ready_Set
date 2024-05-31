//
//  DragAreaView.swift
//  ReadySet
//
//  Created by Nick Molargik on 5/31/24.
//

import SwiftUI

struct DragAreaView: View {
    @Binding var offset: Double

    var body: some View {
        VStack {
            Image(systemName: "chevron.up")
                .foregroundStyle(offset < -50 ? .white : .fontGray)
                .opacity((abs(offset) < 50 || offset < 0) ? 1 : 0)
                .transition(.opacity)

            Rectangle()
                .frame(width: 40)
                .cornerRadius(25)
                .foregroundStyle(.ultraThinMaterial.shadow(.inner(color: .fontGray, radius: 12)))
                .frame(height: 100)
                .padding(.vertical, 10)
                .padding(.horizontal, 2.5)

            Image(systemName: "chevron.down")
                .foregroundStyle(offset > 50 ? .white : .fontGray)
                .opacity((abs(offset) < 50 || offset > 0) ? 1 : 0)
                .transition(.opacity)
        }
        .animation(.spring(dampingFraction: 0.5), value: offset)
        .offset(y: min(max(offset, -200), 200))
        .geometryGroup()
    }
}

#Preview {
    DragAreaView(offset: .constant(0))
        .frame(height: 400)
}
