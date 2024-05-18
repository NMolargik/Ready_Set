//
//  SettingsTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI
import UIKit

struct SettingsTopContentView: View {
    @AppStorage("appState", store: UserDefaults(suiteName: Bundle.main.groupID)) var appState: String = "splash"
    @Environment(\.colorScheme) var colorScheme

    @State var exerciseViewModel: ExerciseViewModel
    @State private var showingDeleteAlert = false

    var body: some View {
        HStack(spacing: 10) {
            settingButton(action: returnToGuide,
                          labelText: "Return To Navigation Tutorial",
                          imageName: "arrowshape.turn.up.backward.2.fill",
                          imageColors: [.purpleStart, .purpleEnd])
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
                Rectangle()
                    .frame(height: 80)
                    .cornerRadius(10)
                    .foregroundStyle(.thinMaterial)
                    .shadow(radius: 1)
                HStack {
                    Spacer()

                    Text(labelText)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.fontGray)

                    Spacer()

                    Image(systemName: imageName)
                        .symbolRenderingMode(.hierarchical)
                        .font(.title)
                        .foregroundStyle(LinearGradient(colors: [imageColors[0], imageColors[1]], startPoint: .leading, endPoint: .trailing))

                    Spacer()
                }
            }
        })
        .buttonStyle(.plain)
    }

    private func returnToGuide() {
        withAnimation {
            appState = "navigationTutorial"
        }
    }
}

#Preview {
    SettingsTopContentView(exerciseViewModel: ExerciseViewModel())
}
