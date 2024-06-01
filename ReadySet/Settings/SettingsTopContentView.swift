//
//  SettingsTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI
import UIKit

struct SettingsTopContentView: View {
    @ObservedObject var exerciseViewModel: ExerciseViewModel

    let vectorURL = "https://www.vecteezy.com/free-vector/iphone-15"

    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 80)
                .cornerRadius(15)
                .foregroundStyle(.thinMaterial)
                .shadow(radius: 1)

            HStack {
                VStack(spacing: 0) {
                    Text("Ready, Set - v\(Bundle.main.bundleVersion)")
                        .bold()
                        .font(.caption)

                    Text("2024, Nicholas Molargik")
                        .font(.caption)

                    Text("Contributions from nythepegasus")
                        .font(.caption)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)

                    Button(action: {
                        UIApplication.shared.open(URL(string: vectorURL)!)
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }, label: {
                        Text("iPhone 15 Vectors by Vecteezy")
                            .font(.caption)
                            .lineLimit(3)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.blue)
                    })
                    .buttonStyle(.plain)
                }

                Spacer()

                ShareLink(
                    item: URL(string: "https://apps.apple.com/app/id6484503374")!,
                    subject: Text("Ready, Set"),
                    message: Text("Check out Ready, Set - a new fitness trend tracking app!")
                ) {
                    ZStack {
                        Rectangle()
                            .cornerRadius(10)
                            .foregroundStyle(.base)

                        Text("Share App")
                            .bold()
                            .foregroundStyle(.purpleStart)
                    }
                }
                .frame(width: 100)

            }
            .padding(.horizontal, 5)
            .padding(.vertical, 8)
        }
        .padding(.leading, 8)
    }
}

#Preview {
    SettingsTopContentView(exerciseViewModel: ExerciseViewModel())
}
