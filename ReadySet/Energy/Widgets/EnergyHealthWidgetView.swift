//
//  EnergyHealthWidgetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI

struct EnergyHealthWidgetView: View {
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            UIApplication.shared.open(URL(string: "x-apple-health://")!)
        }, label: {
            ZStack {
                Circle()
                    .frame(height: 40)
                    .cornerRadius(10)
                    .foregroundStyle(.thinMaterial)
                    .shadow(radius: 1)
                
                Image(systemName: "heart.fill")
                    .foregroundStyle(.pink)
            }
        })
        .buttonStyle(.plain)
    }
}

#Preview {
    EnergyHealthWidgetView()
}
