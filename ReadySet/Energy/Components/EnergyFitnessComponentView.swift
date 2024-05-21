//
//  EnergyFitnessComponentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI

struct EnergyFitnessComponentView: View {
    @State private var showAlert = false

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            guard let url = URL(string: "fitnessapp://") else { return }

            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                showAlert = true
            }
        }, label: {
            ZStack {
                Circle()
                    .frame(height: 40)
                    .cornerRadius(10)
                    .foregroundStyle(.thinMaterial)
                    .shadow(radius: 1)

                Image("rings")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
            }
        })
        .buttonStyle(.plain)
        .alert("Fitness app not installed", isPresented: $showAlert) {
            FitnessAlertButtonsView(showAlert: $showAlert)
        }
    }
}

#Preview {
    EnergyFitnessComponentView()
}
