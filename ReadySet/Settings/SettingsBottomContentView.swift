//
//  SettingsBottomContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct SettingsBottomContentView: View {
    @AppStorage("useMetric", store: UserDefaults(suiteName: Bundle.main.groupID)) var useMetric: Bool = false
    @AppStorage("decreaseHaptics") var decreaseHaptics: Bool = false
    @AppStorage("disableWave") var disableWave: Bool = false
    @AppStorage("moveNavToRight") var moveNavToRight: Bool = false
    @AppStorage("appState", store: UserDefaults(suiteName: Bundle.main.groupID)) var appState: String = "splash"
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Toggle(isOn: $useMetric, label: {
                Text("Use Metric Units")
            })
            .toggleStyle(VerticalToggleStyle(height: 45))
            .padding(.top, 20)
            .padding(.horizontal)
            
            Toggle(isOn: $decreaseHaptics, label: {
                Text("Decrease Haptics")
            })
            .toggleStyle(VerticalToggleStyle(height: 45))
            .padding(.top, 10)
            .padding(.horizontal)

            Toggle(isOn: $disableWave, label: {
                Text("Disable Water Wave Animation")
            })
            .toggleStyle(VerticalToggleStyle(height: 45))
            .padding(.top, 10)
            .padding(.horizontal)

            Toggle(isOn: $moveNavToRight, label: {
                Text("Navigation Handle On Right")
            })
            .toggleStyle(VerticalToggleStyle(height: 45))
            .padding(.top, 10)
            .padding(.horizontal)

            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                withAnimation {
                    returnToGuide()
                }
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.purpleStart, lineWidth: 2)
                        .shadow(radius: 2)
                        .frame(height: 80)

                    HStack {
                        Spacer()

                        Text("Return To Navigation Tutorial")
                            .font(.system(size: 18, weight: .semibold))
                            .multilineTextAlignment(.center)

                        Spacer()

                        Image(systemName: "arrowshape.turn.up.backward.2.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title)
                            .foregroundStyle(LinearGradient(colors: [.purpleStart, .purpleEnd], startPoint: .leading, endPoint: .trailing))

                        Spacer()
                    }
                }
            })
            .buttonStyle(.plain)
            .padding(.top, 10)
            .padding(.horizontal)

            Spacer()

        }
    }

    private func returnToGuide() {
        withAnimation {
            appState = "navigationTutorial"
        }
    }

}

#Preview {
    SettingsBottomContentView()
}
