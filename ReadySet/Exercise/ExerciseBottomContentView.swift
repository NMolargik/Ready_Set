//
//  ExerciseBottomContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct ExerciseBottomContentView: View {
    var body: some View {
        VStack {
            Rectangle()
                .cornerRadius(35)
                .padding(.horizontal, 8)
                .padding(.bottom, 15)
                .foregroundStyle(.ultraThinMaterial)
                .shadow(radius: 1)
        }
    }
}

#Preview {
    ExerciseBottomContentView()
}
