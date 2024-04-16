//
//  SettingsTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct SettingsTopContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 10) {
            settingButton(action: openAppSettings,
                          labelText: "Health\nSettings",
                          imageName: "heart.slash.fill",
                          imageColors: [.black, .red])

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
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
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
            .frame(height: 60)
            .cornerRadius(10)
            .foregroundStyle(.thinMaterial)
            .shadow(radius: 1)
    }

    private func openAppSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(appSettings) {
            DispatchQueue.main.async {
                UIApplication.shared.open(appSettings)
            }
        }
    }

    private func performDeleteAction() {
        // TODO: Placeholder for the delete action
    }
}

#Preview {
    SettingsTopContentView()
}
