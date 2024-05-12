//
//  ExerciseFitnessWidgetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI

struct ExerciseFitnessWidgetView: View {
    @State private var showAlert = false

    var body: some View {
        Button(action: openFitnessApp) {
            ZStack {
                Rectangle()
                    .frame(height: 35)
                    .cornerRadius(10)
                    .foregroundStyle(.thinMaterial)
                    .shadow(radius: 1)

                HStack {
                    Image("rings")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)

                    Text("Fitness")
                        .foregroundStyle(.base).colorInvert()
                }
            }
        }
        .buttonStyle(.plain)
        .alert("Fitness app not installed", isPresented: $showAlert) {
            FitnessAlertButtonsView(showAlert: $showAlert)
        }
    }

    private func openFitnessApp() {
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()

        guard let url = URL(string: "fitnessapp://") else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            showAlert = true
        }
    }
}

#Preview {
    ExerciseFitnessWidgetView()
}
