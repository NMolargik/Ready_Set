//
//  SettingsTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI
import UIKit

struct SettingsTopContentView: View {
    @AppStorage("appState") var appState: String = "splash"
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 10) {
            settingButton(action: returnToOnboarding,
                          labelText: "Go To\nIntro",
                          imageName: "arrowshape.turn.up.backward.2.fill",
                          imageColors: [.red, .red])

            settingButton(action: performDeleteAction,
                          labelText: "Delete\nSet Data",
                          imageName: "trash.fill",
                          imageColors: [.fontGray, .fontGray])
        }
        .padding(.leading, 8)
        .padding(.top, 5)
    }

    private func settingButton(action: @escaping () -> Void, labelText: String, imageName: String, imageColors: [Color]) -> some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            withAnimation {
                action()
            }
        }, label: {
            ZStack {
                defaultRectangle
                HStack {
                    Spacer()
                    Text(labelText)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.fontGray)
                    Spacer()
                    Image(systemName: imageName)
                        .font(.title)
                        .foregroundStyle(imageColors[0], imageColors[1])
                    Spacer()
                }
            }
        })
    }

    private var defaultRectangle: some View {
        Rectangle()
            .frame(height: 80)
            .cornerRadius(10)
            .foregroundStyle(.thinMaterial)
            .shadow(radius: 1)
    }

    private func returnToOnboarding() {
        withAnimation {
            appState = "splash"
        }
    }

    private func performDeleteAction() {
        // TODO: Placeholder for the delete action
    }
}

#Preview {
    SettingsTopContentView()
}
